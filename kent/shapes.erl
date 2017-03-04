-module(shapes).
-export([perimeter/1, area/1, enclose/1]).

% Define a function enclose/1 that takes a shape
% an returns the smallest enclosing rectangle of the shape.

perimeter({circle, R}) ->
    2 * math:pi() * R;

perimeter({rectangle, A, B}) ->
    2 * (A + B);

perimeter({triangle, A, B, C}) ->
    A + B + C.

% Choose a suitable representation of triangles,
% and augment area/1 and perimeter/1 to handle this case too.

area({circle, R}) ->
    math:pi() * math:pow(R, 2);

area({rectangle, A, B}) ->
    A * B;

area(T = {triangle, A, B, C}) ->
    P = perimeter(T) / 2,
    math:sqrt(P * (P - A) * (P - B) * (P - C)).

% Define a function perimeter/1 which takes a shape
% and returns the perimeter of the shape.

enclose({circle, R}) ->
    H = 2 * R,
    {rectangle, H, H};

enclose(Rectangle = {rectangle, _, _}) ->
    Rectangle;

enclose(T = {triangle, A, B, C}) ->
    Side = lists:max([A, B, C]),
    Height = (2 * area(T)) / Side,
    {rectangle, Side, Height}.
