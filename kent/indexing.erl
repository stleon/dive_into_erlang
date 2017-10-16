-module(indexing).
-export([main/1]).


% how to run
% escript indexing.erl LICENSE the

% { "foo" , [{3,5},{7,7},{11,13}] }

search_words(MP, Data, Line) ->
    case re:run(Data, MP, [global, {capture, all, list}]) of
        {match, Captured} ->
            % TODO remove duplicates
            Words = [{string:to_lower(H), Line} || [H | _] <- Captured],
            ets:insert(index, Words);
        nomatch -> ok
    end.


read_by_line(Device, Line) ->
    {ok, MP} = re:compile("\\w{3,}", [caseless]),
    
    case file:read_line(Device) of
        {ok, Data} -> 
            search_words(MP, Data, Line),
            read_by_line(Device, Line + 1);
        eof -> ok
    end.


main([FileName, Word]) ->
    io:format("FILE: ~p~nWORD: ~p~n", [FileName, Word]),
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    ets:new(index, [duplicate_bag, named_table]),
    try
        read_by_line(Device, 1),
        io:format("~p~n", [ets:lookup(index, Word)])
    after
        file:close(Device),
        ets:delete(index),
        erlang:halt(0)
    end.