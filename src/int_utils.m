:- module (int_utils).
:- interface.
:- import_module int, list.
:- type compare ---> eq ; lt ; gt.
:- pred compare(compare::out, int::in, int::in) is det.
:- pred between_integers(int::in, int::in, list(int)::out) is det.
:- implementation.

%:- pragma no_determinism_warning(compare/3).
compare(C, X, Y) :-
    (
	X = Y -> C = eq
    ;
	(
	    X < Y -> C = lt
	;
	    C = gt
	)
    ).



between_integers(X, Y, [X | Is]) :-
    compare(C, X, Y),
(

    C = lt, X1 = X + 1, between_integers(X1, Y, Is)
;

    C = eq, Is = [X]
;
    C = gt, X1 = X - 1, between_integers(X1, Y, Is)
).
