:- module (test_instr).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string, char, day1, list.

:- pred comma_space(char::in) is semidet.
comma_space(',').
comma_space(' ').

% main(!IO) :-
%     Strings = words_separator(comma_space, "hey, man,   ,,,,how are you"),
%     write_list(Strings, " ", write_string, !IO).

main(!IO) :-
    map(parse_instr, ["R11", "L22", "R32"], Is)
    ->
    write_list(Is, "\n",write_instr,!IO);
    write_string("Failed", !IO).
