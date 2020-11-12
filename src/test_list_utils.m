:- module (test_list_utils).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list_utils, list.

main(!IO) :-
    Xs = [1, 2, 3, 4, 5, 6, 7],
    rotate_list(3, Xs, Ys),
    print(Xs, !IO), print(" rotate by 3 :", !IO),
    print(Ys, !IO), nl(!IO).
    
