-module(fib).
-compile(export_all).

fn(0) -> 0;
fn(1) -> 1;
fn(N) -> fb(N - 1, 0, 1).

fb(0, _, B) -> B;

fb(N, A, B) -> fb(N - 1, B, A + B).