-module(recursion).
-export([tail_fac/1, tail_fac/2, tail_len/1, tail_len/2, tail_duplicate/2,
         tail_duplicate/3, tail_reverse/1, tail_reverse/2, tail_sublist/2,
         tail_sublist/3]).

% fac(0) -> 1;
% fac(N) when N > 0 -> N * fac(N - 1).

tail_fac(N) -> tail_fac(N, 1).
tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) when N > 0 -> tail_fac(N-1, N * Acc).

% len([]) -> 0;
% len([_|T]) -> 1 + len(T).

tail_len(L) -> tail_len(L, 0).
tail_len([], Acc) -> Acc;
tail_len([_|T], Acc) -> tail_len(T, Acc + 1).

% duplicate(0, _) -> [];
% duplicate(N, Term) when N > 0 ->
%    [Term|duplicate(N - 1, Term)].

tail_duplicate(N, Term) -> tail_duplicate(N, Term, []).
tail_duplicate(0, _, List) -> List;
tail_duplicate(N, Term, List) when N > 0 -> 
    tail_duplicate(N - 1, Term, [Term|List]).

% reverse([]) -> [];
% reverse([H|T]) -> reverse(T) ++ [H].

tail_reverse(L) -> tail_reverse(L, []).
tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) -> tail_reverse(T, [H|Acc]).

% sub_list([], _) -> [];
% sub_list(_, 0) -> [];
% sub_list([H|T], N) when N > 0 -> [H|sub_list(T, N - 1)].

tail_sublist(L, N) -> tail_reverse(tail_sublist(L, N, [])). % list:reverse
tail_sublist([], _, Sublist) -> Sublist;
tail_sublist(_, 0, Sublist) -> Sublist;
tail_sublist([H|T], N, Sublist) when N > 0 ->
    tail_sublist(T, N - 1, [H|Sublist]).
