:- module (test_array2d_utils).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array2d, list, solutions.
:- import_module array2d_utils.

main(!IO) :-
    test_set(!IO),
    test_iter(!IO).

:- pred test_set(io::di, io::uo) is det.
test_set(!IO) :-
    A = array2d([[1, 2, 3], [4, 5, 6]]),
    set_x(1, [10, 11], A, A1),
    set_y(1, [20, 21, 22], A1, A2),
    print(A1, !IO), nl(!IO),
    print(A2, !IO), nl(!IO).
    
:- pred test_iter(io::di, io::uo) is det.
test_iter(!IO) :-
    A = array2d([[1, 2, 3], [4, 5, 6]]),
    aggregate(array2d_iter(A), cons, []) = B,
    write_list(B, "", print, !IO), nl(!IO).
