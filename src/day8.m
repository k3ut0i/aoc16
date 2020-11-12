:- module(day8).
:- interface.
:- import_module io.

:- pred part1(io::di, io::uo) is det.
:- pred test_count_list(io::di, io::uo) is det.

:- implementation.
:- import_module maybe, string, list, array2d, pair, int, char, solutions.
:- import_module file_utils, list_utils, int_utils, array2d_utils.

:- type axis ---> x ; y.
:- type op ---> rect(x::int, y::int); shift(axis::axis, start::int, num::int).

:- pred parse_op(string::in, op::out) is semidet.
parse_op(S, O) :-
    words(S) = Ws,
    (
	Ws = ["rect", D], split_at_char('x', D) = [XS, YS],
	to_int(XS, X), to_int(YS, Y), O = rect(X, Y)
    ;
	Ws = ["rotate", DS, SS, "by", NS],
	split_at_char('=', SS) = [AxisS, StartS],
	(
	    DS = "column", Axis=x, AxisS="x",
	    to_int(StartS, Start), to_int(NS, Num)
	;
	    DS = "row", Axis=y, AxisS="y",
	    to_int(StartS, Start), to_int(NS, Num)
	),
	    O = shift(Axis, Start, Num)
    ).

:- type pixel ---> on; off.
:- pred empty_screen(int::in, int::in, array2d(pixel)::out) is det.
empty_screen(X, Y, S) :-
    init_list(off, X, Xs),
    init_list(Xs, Y, Ys),  from_lists(Ys) = S.

:- pred count_lit(array2d(pixel)::in, int::out) is det.
% FIXME: Why isn't this working?
% count_lit(A, N) :-
%     Plus = (func(P::in, A1::in) = (A2::out)
% 	is det :- (P=on, Nc=1; P=off, Nc =0), A2 = A1+Nc),
%     aggregate(array2d_iter(A), Plus, 0) = N.
count_lit(As, N) :-
    lists(As) = Pss, foldl((pred(A::in, B::in, C::out) is det :- append(A,B,C)),
	Pss, [], Ps),
    filter((pred(P::in) is semidet :- P=on), Ps, Os),
    length(Os, N).

:- pred update_pixel(pixel::in, pair(int)::in,
    array2d(pixel)::array2d_di, array2d(pixel)::array2d_uo) is det.
update_pixel(P, X-Y, Ain, Aout) :-
    Aout = (Ain ^ elem(X,Y) := P).

:- pred step( op::in, array2d(pixel)::array2d_di,
    array2d(pixel)::array2d_uo) is det.
step(rect(X,Y), Ain, Aout) :-
    between_integers(0, X-1, Xs), between_integers(0, Y-1, Ys),
    cartesian_product(Ys, Xs, Indices),
    foldl_a2d_arg(update_pixel(on), Indices, Ain, Aout).

step(shift(Axis, Start, Num), Ain, Aout) :-
    Axis = x, get_x(Start, Ain, L),
    rotate_list(Num, L, Lnew),
    set_x(Start, Lnew, Ain, Aout)
;
    Axis = y, get_y(Start, Ain, L),
    rotate_list(Num, L, Lnew),
    set_y(Start, Lnew, Ain, Aout).

:- pred pixel_rep(pixel::in, char::out) is det.
pixel_rep(on, '#').
pixel_rep(off, '.').

:- pred print_pixel_line(list(pixel)::in, io::di, io::uo) is det.
print_pixel_line([], !IO).
print_pixel_line([X|Xs], !IO) :-
    pixel_rep(X, C), write_char(C, !IO),
    print_pixel_line(Xs, !IO).

:- pred print_screen(array2d(pixel)::in, io::di, io::uo) is det.
print_screen(A, !IO) :-
    lists(A) = Pss,
    write_list(Pss, "\n", print_pixel_line, !IO).
    
part1(!IO) :-
    read_lines_from_file("../inputs/day8", LinesRes, !IO),
    empty_screen(50, 6, E),
    (
	LinesRes = yes(Lines),
	map_semi(parse_op, Lines, Os),
	foldl_a2d_arg(step, Os, E, A),
	%	write_list(Os, "\n", print, !IO)
	count_lit(A, Lit), format("Number of lit pixels: %i\n", [i(Lit)], !IO),
	print_screen(A, !IO), nl(!IO)
    ;
	LinesRes = no, print("Failed read\n", !IO)
    ).

test_count_list(!IO) :-
    empty_screen(50, 6, E), step(rect(5,5), E, A),
    count_lit(A, Lit), print(Lit, !IO), nl(!IO),
    print_screen(A, !IO), nl(!IO).
