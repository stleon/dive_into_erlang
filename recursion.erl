-module(recursion).
-export([fac/1, fac/2, len/1, len/2]).

fac(N) -> fac(N, 1).
fac(0, Acc) -> Acc;
fac(N, Acc) when N > 0 -> fac(N-1, N * Acc).

len(L) -> len(L, 0).
len([], Acc) -> Acc;
len([_|T], Acc) -> len(T, Acc + 1).