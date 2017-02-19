-module(dolphins).
-compile(export_all).

dolphin() ->
    receive
        {From, do_a_flip} ->
            From ! "How about fuck off?",
            dolphin();
        {From, fish} ->
            From ! "Thx & Bye";
        _ ->
            io:format("hah, we are much clever, than peoples"),
            dolphin()
    end.
