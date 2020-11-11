:- module (list_utils).
:- interface.
:- import_module list.

:- pred transpose(list(list(T))::in, list(list(T))::out) is semidet.
:- pred map(pred(T1, T2, T3), list(T1), list(T2), list(T3)).
:- mode map(pred(in, in, out) is det, in, in, out) is semidet.
:- pred some_list(pred(T), list(T)).
:- mode some_list(pred(in) is semidet, in) is semidet.
:- pred all_list(pred(T), list(T)).
:- mode all_list(pred(in) is semidet, in) is semidet.

:- implementation.

map(_, [], [], []).
map(P, [L1 | Ls1], [L2 | Ls2], [L3 | Ls3]) :-
    call(P, L1, L2, L3), map(P, Ls1, Ls2, Ls3).

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
