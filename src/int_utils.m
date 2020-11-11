:- module (int_utils).
:- interface.
:- import_module int, list.

:- pred between_integers(int::in, int::in, list(int)::out) is det.
:- implementation.

between_integers(X, Y, [X | Is]) :-
    compare(C, X, Y),
(

    C = (<), X1 = X + 1, between_integers(X1, Y, Is)
;

    C = (=), Is = [X]
;
    C = (>), X1 = X - 1, between_integers(X1, Y, Is)
).
