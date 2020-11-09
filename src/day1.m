% -*- mode: mercury -*-
:- module(day1).
:- interface.

:- import_module io, string, list, maybe, pair.

:- type direction ---> left ; right.
:- type instr ---> instr( d :: direction, steps :: int).
:- type pos ---> pos(dir, pair(int, int)).
:- type dir ---> north ; east ; south ; west.

:- pred read_instr(string::in, list(instr)::out) is semidet.
:- pred read_line_from_file(string::in, maybe(string)::out,
    io::di, io::uo) is det.
:- pred write_instr(instr::in, io::di, io::uo) is det.
:- pred parse_instr(string::in, instr::out) is semidet.
:- pred read_instr_from_file(string::in, list(instr)::out, io::di, io::uo) is det.
:- pred calculate_end(list(instr)::in, pair(int, int)::out) is semidet.
:- pred calculate_trail(list(instr)::in, list(pos)::out) is semidet.
:- pred find_visited(list(pos)::in, pair(int, int)::out) is semidet.
:- pred flesh_trail(list(pos)::in, list(pair(int))::out) is det.
:- pred find_first_dup(list(T)::in, T::out) is semidet.

:- implementation.
:- import_module char, int, enum.
:- import_module int_utils.

:- pred parse_direction(char::in, direction::out) is semidet.
parse_direction('R', right).
parse_direction('L', left).

parse_instr(S, instr(D, N)) :-
    first_char(S, C, Ns), parse_direction(C, D),
    base_string_to_int(10, Ns, N).

write_instr(instr(D, N), !IO) :-
    (D = left, C = 'L'; D = right, C = 'R'),
    write_char(C, !IO), write_int(N, !IO).

:- pred comma_space(char::in) is semidet.
comma_space(',').
comma_space(' ').

read_instr(String, Is) :-
    IsStrings = words_separator(comma_space, String),
    map(parse_instr, IsStrings, Is).

read_line_from_file(File, StringRes, !IO) :-
    open_input(File, OpenResult, !IO),
    (
	OpenResult = ok(Stream),
	read_line_as_string(Stream, ReadResult, !IO),
	(
	    ReadResult = ok(String) -> StringRes = yes(String);
	    StringRes = no
	)
    ;
     %     OpenResult = eof, StringRes = eof;
	OpenResult = error(_), StringRes = no).


:- instance enum(dir) where [
to_int(north) = 0, to_int(south) = 2, to_int(east) = 1, to_int(west) = 3,
from_int(0) = north, from_int(1) = east, from_int(2) = south, from_int(3) = west 
].


%write_pos(pos(D, X - Y), !IO) :- write_int(to_int(D), !IO), write_string(":", !IO),    write_int
% Clock wise directions N-0, E-1, S-2, W-3
:- pred step(instr::in, pos::in, pos::out) is semidet.
step(instr(D, L), pos(DC, X - Y), pos(DN, X1 - Y1)) :-
    (D = left, Diff = -1; D = right, Diff = 1),
    D1 = (to_int(DC)+Diff) mod 4, DN = from_int(D1),
    (
	DC = north, X1 = X + Diff * L, Y = Y1;
	DC = south, X1 = X - Diff * L, Y = Y1;
	DC = east, X1 = X, Y1 = Y - Diff * L;
	DC = west, X1 = X, Y1 = Y + Diff * L
    ).
calculate_end(Ds, X - Y) :-
    foldl(step, Ds, pos(north, 0 - 0), pos(_, X - Y)).

:- pred calculate_trail(pos::in, list(instr)::in,
    list(pos)::in, list(pos)::out) is semidet.
calculate_trail(Ds, Ls) :- calculate_trail(pos(north, 0 - 0), Ds, [], Ls).
calculate_trail(P, [], Acc, Ls) :- reverse([P | Acc], Ls).
calculate_trail(P, [I | Is], Acc, Ls) :-
    step(I, P, PN), calculate_trail(PN, Is, [P | Acc], Ls).


find_first_dup([X | Xs], Y) :-
    member(X, Xs) -> Y = X;
    find_first_dup(Xs, Y).

:- pred create_pair(T1::in, T2::in, pair(T1, T2)::out) is det.
create_pair(X1, X2, X1 - X2).

:- pred flesh_points(pos::in, pos::in, list(pair(int))::out) is det.
flesh_points(pos(_, X1 - Y1), pos(D, X2 - Y2), Ts) :-
    (
	(D = north; D = south), X1 = X, % X1 = X2
	between_integers(Y1, Y2, Ys),
	map(create_pair(X), Ys, Ts)
    ;
	(D = east; D = west), Y1 = Y,	
	between_integers(X1, X2, Xs),
	map(pred(X::in, P::out) is det :- create_pair(X, Y, P), Xs, Ts)
    ).


flesh_trail([], []).
flesh_trail([_], []).
flesh_trail([P1, P2 | Ps], Ts ++ Tss) :-
    flesh_points(P1, P2, Ts), flesh_trail([P2 | Ps], Tss).

:- pred ignore_dir(pos::in, pair(int, int)::out) is det.
ignore_dir(pos(_, Pair), Pair).

find_visited(Trail, X - Y) :-
    map(ignore_dir, Trail, Ts),
    find_first_dup(Ts, X - Y).
%% Why is this complaing of mostly_unique to unique problem in IO argument? 
%% main(!IO) :- (read_line_from_file("../inputs/day1", yes(S), !IO) ->
%% 		     (read_instr(S, Is) -> write_list(Is, "\n", write_instr, !IO);
%% 		      write_string("Failed", !IO))
%% 		 ;
%% 		 write_string("Failed", !IO)).
    

read_instr_from_file(File, Is, !IO) :-
    read_line_from_file(File, FileRes, !IO),
    (
	FileRes = yes(Str),
	(
	    read_instr(Str, Is1) -> Is = Is1
	;
	    Is = []
	)
    ;
	FileRes = no, Is = []
    ).
