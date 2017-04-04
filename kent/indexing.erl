-module(indexing).
-compile(export_all).

% { "foo" , [{3,5},{7,7},{11,13}] }

search_words(MP, Data, Line) ->
    case re:run(Data, MP, [global, {capture, all, list}]) of
        {match, Captured} ->
            % TODO remove duplicates
            Words = [{string:to_lower(H), Line} || [H | _] <- Captured],
            ets:insert(index, Words);
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
    % TODO promt file_name
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    ets:new(index, [duplicate_bag, named_table]),
    try
        % TODO promt
        read(Device),
        ets:lookup(index, "the")
    after
        file:close(Device),
        ets:delete(index)
    end.