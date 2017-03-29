-module(indexing).
-compile(export_all).

% { "foo" , [{3,5},{7,7},{11,13}] }

clean_line(Data) when length(Data) < 3 -> [];

clean_line(Data) when length(Data) >= 3 ->
    io:format("Get: ~s ~n", [Data]),
    Line = string:to_lower(Data),
    Tokens = string:tokens(Line, " "),
    Tokens.

cleaner(Data) ->
    io:format("Get: ~s ~n", [Data]),
    Data.

read(Device) ->
    case file:read_line(Device) of
        % line numbers
        % remove all, that not character
        {ok, Data} -> [cleaner(Data) | read(Device)];
        eof -> []
    end.

run(FileName) ->
    {ok, MP} = re:compile("\\w{3,}", [caseless]),
    {match, Captured} =  re:run("Oh Lol match here no", MP,
                                                [global, {capture, all, list}]),
    {ok, Device} = file:open(FileName, [read, raw, read_ahead]),
    try read(Device)
      after file:close(Device)
    end.