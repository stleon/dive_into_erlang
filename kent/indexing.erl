-module(indexing).
-compile(export_all).

% { "foo" , [{3,5},{7,7},{11,13}] }

clean_line(Data) when length(Data) < 3 -> [];

clean_line(Data) when length(Data) >= 3 ->
    io:format("Get: ~s ~n", [Data]),
    Line = string:to_lower(Data),
    Tokens = string:tokens(Line, " "),
    Tokens.

read(Device) ->
    case file:read_line(Device) of
        % line numbers
        {ok, Data} -> [clean_line(string:strip(Data, both)) | read(Device)];
        eof -> []
    end.

run(FileName) ->
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    try read(Device)
      after file:close(Device)
    end.