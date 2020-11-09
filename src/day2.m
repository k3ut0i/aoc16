:- module (day2).
:- interface.
:- import_module list, pair.
:- type move_code ---> up ; down ; left ; right.
:- type idx ---> one ; two ; three.

:- pred parse_line(string::in, list(move_code)::out) is semidet.
:- pred move(list(move_code)::in, pair(idx)::in, pair(idx)::out) is det.
:- pred all_moves(list(list(move_code))::in, pair(idx)::in,
    list(pair(idx))::out) is det.
:- pred lookup(pair(idx)::in, int::out) is det.
:- pred all_moves2(list(list(move_code))::in, pair(int)::in,
    list(pair(int))::out) is det.

:- implementation.
:- import_module io, char, string, int.
:- import_module file_utils.


:- pred inc(idx::in, idx::out) is det.
inc(one, two).
inc(two, three).
inc(three, three).

:- func to_int(idx::in) = (int::out) is det.
to_int(one) = 1.
to_int(two) = 2.
to_int(three) = 3.


lookup(X - Y, I) :- I = (to_int(Y)-1)*3 + to_int(X).

:- pred dec(idx::in, idx::out) is det.
dec(one, one).
dec(two, one).
dec(three, two).

:- pred move_step(move_code::in, pair(idx)::in, pair(idx)::out) is det.
move_step(up, X - Y, X - Y1) :- dec(Y, Y1).
move_step(down, X - Y, X - Y1) :- inc(Y, Y1).
move_step(left, X - Y, X1 - Y) :- dec(X, X1).
move_step(right, X - Y, X1 - Y) :- inc(X, X1).

:- pred parse_code(char::in, move_code::out) is semidet.
parse_code('R', right).
parse_code('L', left).
parse_code('D', down).
parse_code('U', up).

parse_line(S, Ms) :-
    map(parse_code, to_char_list(strip(S)), Ms).

move(Cs, In, Out) :-
    foldl(move_step, Cs, In, Out).

%% Since I am accumulating them, they are in reverse order.
all_moves(Css, InitPos, Ps) :-
    foldl((pred(Cs::in, (Pos - Acc)::in , (Pos1 - [Pos1 | Acc])::out) is det :-
	move(Cs, Pos, Pos1)),Css, pair(InitPos, []), AllMoves),
    snd(AllMoves) = Ps.

%% Part 2 has wildly different keyboard. Cant extend the previous one.
:- pred step(move_code::in, pair(int)::in, pair(int)::out) is det.
step(D, X - Y, X1 - Y1) :-
    (
	D = up, XT = X, YT = Y - 1
    ;
	D = down, XT = X, YT = Y + 1
    ;
	D = left, XT = X - 1, YT = Y
    ;
	D = right, XT = X + 1, YT = Y
    ),
	(
	    abs(XT) + abs(YT) > 2 -> X1 = X, Y1 = Y
	;
	    X1 = XT, Y1 = YT
	).
:- pred move2(list(move_code)::in, pair(int)::in, pair(int)::out) is det.
move2(Cs, In, Out) :-
    foldl(step, Cs, In, Out).


all_moves2(Css, InitPos, Ps) :-
    foldl((pred(Cs::in, (Pos - Acc)::in , (Pos1 - [Pos1 | Acc])::out) is det :-
	move2(Cs, Pos, Pos1)),Css, pair(InitPos, []), AllMoves),
    snd(AllMoves) = Ps.
