:- module (test_int_utils).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int_utils, list.

:- pred test_between_integers(io::di, io::uo) is det.
test_between_integers(!IO) :-
    between_integers(0, 9, X), Xd = remove_dups(X),
    (
	((length(X, 10), length(Xd, 10)) ->
	    print("Passed test\n", !IO)
	;
	    print("Failed: ", !IO), print(X, !IO), nl(!IO), print(Xd, !IO)
	)
    ).

main(!IO) :- test_between_integers(!IO).
