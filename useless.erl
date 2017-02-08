-module(useless).
-export([add/2, hello/0, greet_and_add_two/1]).
-compile([debug_info, export_all]).

add(X, Y) ->
    X + Y.

%% hello
hello() ->
    io:format("Привет, мир!~n").

greet_and_add_two(X) ->
    hello(),
    add(X, 2).

