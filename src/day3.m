:- module(day3).
:- interface.
:- import_module io.

:- pred part1(io::di, io::uo) is det.
:- pred part2(io::di, io::uo) is det.

:- implementation.
:- import_module integer, uint, list, maybe, string, solutions.
:- import_module file_utils.

:- pred triangle(uint::in, uint::in, uint::in) is semidet.
triangle(X, Y, Z) :- X + Y > Z, X + Z > Y, Y + Z > X.

:- pred tri(list(uint)::in) is semidet.
tri([X, Y, Z]) :- triangle(X, Y, Z).

:- pred line_to_uints(string::in, list(uint)::out) is semidet.
line_to_uints(S, Is) :-
    map(from_string, words(S), Ts),
    map(to_uint, Ts, Is).

:- pred read_triangles(string::in, list(list(uint))::out, io::di, io::uo) is det.
read_triangles(File, Ts, !IO) :-
	read_lines_from_file(File, LinesRes, !IO),
    (
	LinesRes = yes(Lines) ->
	(
	    map(line_to_uints, Lines, Ts1) ->
	    Ts = Ts1
	;
	    Ts = []
	)
    ;
	Ts = []
    ).

part1(!IO) :-
    read_triangles("../inputs/day3", Ts, !IO),
%   write_list(Ts, "\n", print, !IO),
    filter(tri, Ts, Ts1),
    length(Ts1, C), print(C, !IO), nl(!IO).

%% Something like this should be trivially specified in DCG.
%% I need to learn how to do that.
:- pred split_columns(list(list(uint))::in, list(uint)::out,
    list(uint)::out, list(uint)::out) is semidet.
split_columns([], [], [], []).
split_columns([[A1, A2, A3] | Rest], [A1 | R1], [A2 | R2], [A3 | R3]) :-
    split_columns(Rest, R1, R2, R3).

:- pred tri_column(list(uint)::in, uint::out, uint::out, uint::out) is nondet.
tri_column(Ls, X, Y, Z) :-
    member(X, Ls), delete(Ls, X, LsX),
    member(Y, LsX), delete(LsX, Y, LsY),
    member(Z, LsY), triangle(X, Y, Z).

:- pred num_of_tri(list(uint)::in, int::out) is det.
num_of_tri(Ls, N) :-
    solutions((pred(T::out) is nondet :- tri_column(Ls, X, Y, Z), T = [X, Y, Z]), Ss),
    length(Ss, N).
	

part2(!IO) :-
    read_triangles("../inputs/day3", Ts, !IO),
    (
	split_columns(Ts, G1, G2, G3) ->
	map(num_of_tri, [G1, G2, G3], N),
	print(N, !IO)
    ;
	print("Could not split columns", !IO)
    ).
