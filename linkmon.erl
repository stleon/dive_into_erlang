-module(linkmon).
-compile([export_all]).

% link(spawn(fun linkmon:myproc/0)).
myproc() ->
    timer:sleep(5000),
    exit(lol).

start_critic() -> 
    spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
        {Pid, Criticism} -> Criticism
    after 2000 ->
        timeout
    end.

critic() ->
    receive
        {From, {"test_band", "test_album"}} ->
            From ! {self(), "nice!"};
        {From, {"test_band2", "test_album2"}} ->
            From ! {self(), "nice2!"};
        {From, {"test_band3", "test_album3"}} ->
            From ! {self(), "nice3!"};
        {From, _} ->
            From ! {self(), "fuck off!!"}
    end,
    critic().