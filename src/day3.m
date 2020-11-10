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
    length(Ts1, C),
    format("Triangles possible: %i\n", [i(C)], !IO).

%% Something like this should be trivially specified in DCG.
%% I need to learn how to do that.
:- pred split_columns(list(list(uint))::in, list(uint)::out,
    list(uint)::out, list(uint)::out) is semidet.
split_columns([], [], [], []).
split_columns([[A1, A2, A3] | Rest], [A1 | R1], [A2 | R2], [A3 | R3]) :-
    split_columns(Rest, R1, R2, R3).

%% I HAVE MISUNDESTOOD THE PROBLEM
%% I assumed given a set of lengths, get me all possible triangles with
%% lengths from this set. It is likely not what is actually required.

% :- pred tri_column(list(uint)::in, uint::out, uint::out, uint::out) is nondet.
% tri_column(Ls, X, Y, Z) :-
%     member(X, Ls), Y > X, member(Y, Ls),
%     Z > Y, Z < X + Y, member(Z, Ls).

% :- pred triangles(list(uint)::in, list(list(uint))::out) is det.
% triangles(Ls, Ss) :-
%     solutions((pred(T::out) is nondet :- tri_column(Ls, X, Y, Z), T = [X, Y, Z]), Ss).

% :- pred num_of_tri(list(uint)::in, int::out) is det.
% num_of_tri(Ls, N) :-
%     triangles(Ls, Ss), length(Ss, N).


:- pred count_triangles(list(uint)::in, uint::out) is semidet.
count_triangles([], 0u).
count_triangles([X, Y, Z | Rest], N) :-
    triangle(X, Y, Z) -> count_triangles(Rest, NR), N = NR+1u
;
    count_triangles(Rest, N).

part2(!IO) :-
    read_triangles("../inputs/day3", Ts, !IO),
    (
	split_columns(Ts, G1, G2, G3) ->
	(
	    map(count_triangles, [G1, G2, G3], [N1, N2, N3]) ->
	    format("Triangles in each column: %u %u %u, Total: %u.\n",
		[u(N1), u(N2), u(N3), u(N1+N2+N3)], !IO)
	;
	    print("Could not count triangles", !IO)
	    )
    ;
	print("Could not split columns", !IO)
    ).
