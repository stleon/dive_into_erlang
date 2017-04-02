-module(indexing).
-compile(export_all).

% { "foo" , [{3,5},{7,7},{11,13}] }

search_words(MP, Data) -> 
    case re:run(Data, MP, [global, {capture, all, list}]) of
        {match, Captured} -> [string:to_lower(X) || X <- lists:merge(Captured)];
        nomatch -> [] % not empty results
    end.


read(Device) ->
    {ok, MP} = re:compile("\\w{3,}", [caseless]),
    
    case file:read_line(Device) of
        {ok, Data} -> [search_words(MP, Data) | read(Device)];
        eof -> []
    end.

run(FileName) ->
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    try read(Device)
      after file:close(Device)
    end.