:- module (test_day6).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module day6.

main(!IO) :- part1and2(!IO).
