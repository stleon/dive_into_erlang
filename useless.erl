-module(useless).
-compile([debug_info, {d, debugmode}]).
-define(sub(X, Y), X - Y).
-define(MACRO, 18).
-ifdef(debugmode).
-define(DEBUG(S), io:format("dbg: " ++ S)).
-else.
-define(DEBUG(S), ok).
-endif.
-export([add/2, hello/0, greet_and_add_two/1, use_macro/0]).

add(X, Y) ->
    ?DEBUG("in add func"),
    X + Y.

use_macro() ->
    ?MACRO + ?sub(10, 9).

%% hello
hello() ->
    io:format("Привет, мир!~n").

greet_and_add_two(X) ->
    hello(),
    add(X, 2).

