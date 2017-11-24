-module(indexing).
-export([main/1]).


% how to run
% escript indexing.erl shapes.erl the

% { "foo" , [{3,5},{7,7},{11,13}] }

search_words(CompRegex, Data, Line) ->
    case re:run(Data, CompRegex, [global, {capture, all, list}]) of
        {match, Captured} ->
            % TODO remove duplicates
            Words = [{string:to_lower(H), Line} || [H | _] <- Captured],
            ets:insert(index, Words);
        nomatch -> ok
    end.


read_by_line(Device, CompRegex, Line) ->

    case file:read_line(Device) of
        {ok, Data} -> 
            search_words(CompRegex, Data, Line),
            read_by_line(Device, CompRegex, Line + 1);
        eof -> ok
    end.


is_valid_file(FileName) ->
    case file:open(FileName, [read, raw, read_ahead]) of
        {ok, Device} ->
            Device;
        {error, Reason} ->
            exit(Reason)
    end.


main([FileName, Word]) when is_list(FileName) and is_list(Word) ->
    io:format("FILE: ~p~nWORD: ~p~n", [FileName, Word]),

    Device = is_valid_file(FileName),
    {ok, CompRegex} = re:compile("\\w{3,}", [caseless]),
    ets:new(index, [duplicate_bag, named_table]),

    try
        read_by_line(Device, CompRegex, 1),
        io:format("~p~n", [ets:lookup(index, Word)])
    after
        file:close(Device),
        ets:delete(index)
        % erlang:halt(0)
    end.
