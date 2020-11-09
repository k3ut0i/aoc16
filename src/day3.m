:- module(day3).
:- interface.
:- import_module io.

:- pred part1(io::di, io::uo) is det.

:- implementation.
:- import_module integer, uint, list, maybe, string.
:- import_module file_utils.

:- pred triangle(uint::in, uint::in, uint::in) is semidet.
triangle(X, Y, Z) :- X + Y > Z, X + Z > Y, Y + Z > X.

:- pred tri(list(uint)::in) is semidet.
tri([X, Y, Z]) :- triangle(X, Y, Z).

:- pred list_to_uint(list(string)::in, list(uint)::out) is semidet.
list_to_uint(Ss, Is) :-
    map(from_string, Ss, Ts),
    map(to_uint, Ts, Is).

:- pred read_triangles(string::in, list(list(uint))::out, io::di, io::uo) is det.
read_triangles(File, Ts, !IO) :-
	read_lines_from_file(File, LinesRes, !IO),
    (
	LinesRes = yes(Lines) ->
	(
	    map((pred(Line::in, Sides::out) is semidet :-
		words(Line) = Words, list_to_uint(Words, Sides)),
	    Lines, Ts1) -> Ts = Ts1
	;
	    Ts = []
	)
    ;
	Ts = []
    ).

part1(!IO) :-
    read_triangles("../inputs/day3", Ts, !IO),
    write_list(Ts, "\n", print, !IO),
    filter(tri, Ts, Ts1),
    length(Ts1, C), print(C, !IO).
