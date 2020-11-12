:- module(array2d_utils).
:- interface.
:- import_module list, array2d.

:- pred foldl_a2d_arg(pred(L, A, A), list(L), A, A).
:- mode foldl_a2d_arg(pred(in, array2d_di, array2d_uo) is det, in, array2d_di, array2d_uo) is det.

:- pred get_x(int::in, array2d(T)::in, list(T)::out) is det.
:- pred get_y(int::in, array2d(T)::in, list(T)::out) is det.

:- pred set_x(int::in, list(T)::in, array2d(T)::array2d_di,
    array2d(T)::array2d_uo) is det.
:- pred set_y(int::in, list(T)::in, array2d(T)::array2d_di,
    array2d(T)::array2d_uo) is det.

:- pred array2d_iter(array2d(T)::in, T::out) is nondet.

:- implementation.
:- import_module pair, int, require.
:- import_module int_utils, list_utils.

foldl_a2d_arg(_, [], A, A).
foldl_a2d_arg(P, [X | Xs], Ain, Aout) :-
    call(P, X, Ain, AT),
    foldl_a2d_arg(P, Xs, AT, Aout).

:- type axis ---> row ; column.

:- pred get(axis::in, int::in, array2d(T)::array2d_ui, list(T)::out) is det.
get(Axis, N, A, L) :-
    bounds(A, Rows, Columns),
    (    
	Axis = row, between_integers(0, Columns-1, Indices),
	map((pred(Y::in, E::out) is det :- A ^ elem(N,Y) = E), Indices, L)
    ;
	Axis = column, between_integers(0, Rows-1, Indices),
	map((pred(X::in, E::out) is det :- A ^ elem(X, N) = E), Indices, L)
    ).

get_x(N, A, L) :- get(column, N, A, L).
get_y(N, A, L) :- get(row, N, A, L).

:- pred set(axis::in, int::in, list(T)::in, array2d(T)::array2d_di,
    array2d(T)::array2d_uo) is det.
set(Axis, N, L, Ain, Aout) :-
    bounds(Ain, Rows, Columns),
    (
	Axis = row, between_integers(0, Columns-1, Indices),
	(
	    zip_with((pred(A::in, B::in, A-B::out) is det), Indices, L, LI) ->
	    P = (pred(Y-V::in, A1::array2d_di, A2::array2d_uo) is det :-
		A2 = (A1 ^ elem(N, Y) := V)),
	    foldl_a2d_arg(P, LI, Ain, Aout)
	;
	    unexpected($pred, "Length of the list and that of axis is not equal")
	)
    ;
	Axis = column, between_integers(0, Rows-1, Indices),
	(
	    zip_with((pred(A::in, B::in, A-B::out) is det), Indices, L, LI) ->
	    P = (pred(X-V::in, A1::array2d_di, A2::array2d_uo) is det :-
		A2 = (A1 ^ elem(X,N) := V)),
	    foldl_a2d_arg(P, LI, Ain, Aout)
	;
	    unexpected($pred, "Length of the list and that of axis is not equal")
	)
    ).

set_x(N, L, Ain, Aout) :- set(column, N, L, Ain, Aout).
set_y(N, L, Ain, Aout) :- set(row, N, L, Ain, Aout).

array2d_iter(A, X) :-
    bounds(A, Rows, Columns), between_integers(0, Rows-1, Rs),
    between_integers(0, Columns-1, Cs),
    member(C, Cs), member(R, Rs), A ^ elem(R, C) = X.
