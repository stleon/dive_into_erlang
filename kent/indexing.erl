-module(indexing).
-compile(export_all).

% { "foo" , [{3,5},{7,7},{11,13}] }

insert([H | _], Line) ->
    % TODO insert all line at once
    % ets:insert(index, {string:to_lower(Word), Line}).
    io:format("~p: ~p~n", [string:to_lower(H), Line]),
    ets:insert(index, {string:to_lower(H), Line}).


search_words(MP, Data, Line) ->
    case re:run(Data, MP, [global, {capture, all, list}]) of
        {match, Captured} ->
            % Captured = [["MIT"],["License"]]
            lists:foreach(fun(Word) -> insert(Word, Line) end, Captured);
        nomatch -> ok
    end.


read(Device) -> read(Device, 1).
read(Device, Line) ->
    {ok, MP} = re:compile("\\w{3,}", [caseless]),
    
    case file:read_line(Device) of
        {ok, Data} -> 
            search_words(MP, Data, Line),
            read(Device, Line + 1);
        eof -> ok
    end.


run(FileName) ->
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    ets:new(index, [duplicate_bag, named_table]),
    try 
        read(Device)
    after
        file:close(Device),
        ets:delete(index)
    end.