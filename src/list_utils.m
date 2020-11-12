:- module (list_utils).
:- interface.
:- import_module list, int, pair.

:- pred transpose(list(list(T))::in, list(list(T))::out) is semidet.

:- pred map(pred(T1, T2, T3), list(T1), list(T2), list(T3)).
:- mode map(pred(in, in, out) is det, in, in, out) is semidet.

:- pred map_semi(pred(T1, T2), list(T1), list(T2)).
:- mode map_semi(pred(in, out) is semidet, in, out) is det.

:- pred some_list(pred(T), list(T)).
:- mode some_list(pred(in) is semidet, in) is semidet.

:- pred all_list(pred(T), list(T)).
:- mode all_list(pred(in) is semidet, in) is semidet.

:- pred init_list(T::in, int::in, list(T)::out) is det.

:- pred zip_with(pred(T1, T2, T3), list(T1), list(T2), list(T3)).
:- mode zip_with(pred(in, in, out) is det, in, in, out) is semidet.

:- pred cartesian_product(list(T1)::in, list(T2)::in, list(pair(T1,T2))::out) is det.

%% Forward when positive
:- pred rotate_list(int::in, list(T)::in, list(T)::out) is det.

:- implementation.

:- import_module require.
map(_, [], [], []).
map(P, [L1 | Ls1], [L2 | Ls2], [L3 | Ls3]) :-
    call(P, L1, L2, L3), map(P, Ls1, Ls2, Ls3).

%% Combining filter with map. Equivalent of the following
%% filter(pred(X) :- P(X,_), Xs, Xt), map(P, Xt, Ys)
map_semi(_, [], []).
map_semi(P, [X | Xs], Ys) :-
    (
	call(P, X, Y1) ->
	map_semi(P, Xs, Ys1), Ys = [Y1 | Ys1]
    ;
	map_semi(P, Xs, Ys)
    ).

transpose([As], Ass) :- map(pred(X::in, [X]::out) is det, As, Ass).
transpose([As1, As2 | Ass], Bss) :-
    transpose([As2 | Ass], Bss1),
    map(cons, As1, Bss1, Bss).

some_list(P, [X|Xs]) :-
    call(P, X);
    some_list(P, Xs).

all_list(_, []).
all_list(P, [X|Xs]) :-
    call(P, X), all_list(P, Xs).


init_list(X, N, Ls) :-
    compare(C, N, 0),
    (
	C = (<), unexpected($pred, "Negative length of list")
    ;
	C = (=), Ls = []
    ;
	C = (>), Ls = [X|Ls1], init_list(X, N-1, Ls1)
    ).

zip_with(_, [], [], []).
zip_with(P, [X|Xs], [Y|Ys], [XY|XYs]) :-
    call(P, X, Y, XY),
    zip_with(P, Xs, Ys, XYs).

cartesian_product([], _, []).
cartesian_product([X|Xs], Ys, XYs ++ XsYs) :-
    map((pred(Y::in, XY::out) is det :- XY=pair(X,Y)), Ys, XYs),
    cartesian_product(Xs, Ys, XsYs).


rotate_list(N, Xs, Ys) :-
    (
	Xs = [] -> Ys = []
    ;
	N1 = length(Xs)  - (N mod length(Xs)),
	det_split_list(N1, Xs, Last, First), %% Should not fail
	Ys = First ++ Last
    ).
