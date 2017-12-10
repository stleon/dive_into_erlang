-module(indexing).
-export([main/1]).
-define(CompRegex, re:compile("\\w{3,}", [caseless])).

% task
% https://www.futurelearn.com/courses/functional-programming-erlang/1/assignments/161822/

% how to run
% get files from task dickens-christmas.txt & gettysburg-address.txt
% escript indexing.erl gettysburg-address.txt foo

% { "foo" , [{3,5},{7,7},{11,13}] }

search_words(Data, Line) ->
    % run regex and insert proplist to ets table
    {ok, MP} = ?CompRegex,
    case re:run(Data, MP, [global, {capture, all, list}]) of
        {match, Captured} ->
            % TODO some overhead here -- remove duplicates
            Words = [{string:to_lower(H), Line} || [H | _] <- Captured],
            ets:insert(index, Words);
        nomatch -> ok
    end.


read_by_line(Device, Line) ->
    % read file by line and run search words (by pattern)
    case file:read_line(Device) of
        {ok, Data} -> 
            search_words(Data, Line),
            read_by_line(Device, Line + 1);
        eof -> ok
    end.


is_valid_file(FileName) ->
    % open file and return descriptor, else exit()
    case file:open(FileName, [read, raw, read_ahead]) of
        {ok, Device} ->
            Device;
        {error, Reason} ->
            exit(Reason)
    end.


main([FileName, Word]) when is_list(FileName) and is_list(Word) ->
    io:format("FILE: ~p~nWORD: ~p~n", [FileName, Word]),

    Device = is_valid_file(FileName),
    ets:new(index, [bag, named_table]),

    try
        read_by_line(Device, 1),
        io:format("~p: ~p", [Word, to_range(ets:lookup(index, Word))])
    after
        file:close(Device),
        ets:delete(index)
        % erlang:halt(0)
    end.


to_range(L) ->
    % converts
    % [{"the",3}, {"the",15}, {"the",17}, {"the",18}, {"the",19}]
    % to [{3, 3}, {15, 15}, {17, 19}]
    % so its something like range =)
    to_range(L, []).

to_range([], Acc) -> lists:reverse(Acc);

to_range([{_, LineNum}|T], []) ->
    to_range(T, [{LineNum, LineNum}]);

to_range([{_, LineNum}|T], Acc) ->
    [{Start, End}|T1] = Acc,
    if
        LineNum - End =< 1 ->
            to_range(T, [{Start, LineNum}|T1]);
        LineNum - End > 1 ->
            to_range(T, [{LineNum, LineNum}|Acc])
    end.