-module(bits_sum).
-export([bits_direct/1, bits_tail/1]).

% Define a function bits/1 that takes a positive integer N
% and returns the sum of the bits in the binary representation. 
% For example bits(7) is 3 and bits(8) is 1.

bits_ditry(N) when N > 0 ->
    Bits = integer_to_list(N, 2),
    Tokens = string:tokens(Bits, "0"),  % ["1", "1", ..] 
    length(Tokens).


% https://en.wikipedia.org/wiki/Hamming_weight

bits_direct(0) -> 0;

bits_direct(N) ->
    bits_direct(N band (N - 1)) + 1.

bits_tail(N) ->
    bits_tail(N, 0).

bits_tail(0, Acc) ->
    Acc;
bits_tail(N, Acc) ->
    bits_tail(N band (N - 1), Acc + 1).
