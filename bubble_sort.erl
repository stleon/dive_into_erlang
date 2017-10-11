-module(bubble_sort).
-compile(export_all).

bubble_sort([]) -> [];
bubble_sort(List) -> bbs(List, [], false).


bbs([], Acc, true) -> lists:reverse(Acc);

bbs([], Acc, false) -> bbs(lists:reverse(Acc), [], true);

bbs([X1, X2 | Tail], Acc, _) when X1 > X2 ->
    bbs([X1 | Tail], [X2 | Acc], false);

bbs([H | T], Acc, Stop) ->
    bbs(T, [H | Acc], Stop).
