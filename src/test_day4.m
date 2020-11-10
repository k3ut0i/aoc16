:- module (test_day4).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module day4.

main(!IO) :-
    part1(!IO),
    part2(!IO).
