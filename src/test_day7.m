:- module (test_day7).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module(day7).

main(!IO) :-
    part1and2(!IO).
