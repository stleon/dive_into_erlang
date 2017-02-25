-module(linkmon).
-compile([export_all]).

% link(spawn(fun linkmon:myproc/0)).
myproc() ->
    timer:sleep(5000),
    exit(lol).
