:- module (test_day2).
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module maybe, list, string, pair.
:- import_module file_utils, day2.

:- pred part1(io::di, io::uo) is det.
part1(!IO) :-
    read_lines_from_file("../inputs/day2", LinesRes, !IO),
    (
	LinesRes = yes(Lines),
	(
	    map(parse_line, Lines, Codes) ->
	    all_moves(Codes, pair(two, two), Pss),
	    map(lookup, Pss, NumRev), reverse(Num, NumRev),
	    print(Num, !IO)
	;
	    write_list(Lines, "\n", print, !IO),
	    write_string("Failed parsing lines", !IO)
	)
    ;
	LinesRes = no, write_string("Failed reading lines", !IO)
    ).

:- pred part2(io::di, io::uo) is det.
part2(!IO) :-
    read_lines_from_file("../inputs/day2", LinesRes, !IO),
    (
	LinesRes = yes(Lines),
	(
	    map(parse_line, Lines, Codes) ->
	    all_moves2(Codes, pair(-2, 0), Pss),
	    reverse(Pss, Rss), print(Rss, !IO)
	;
	    write_list(Lines, "\n", print, !IO),
	    write_string("Failed parsing lines", !IO)
	)
    ;
	LinesRes = no, write_string("Failed reading lines", !IO)
    ).

main(!IO) :-
    write_string("Part1 Pass: ", !IO), part1(!IO), nl(!IO),
    %% Easier to manually decode the answer than to code that awful keyboard
    write_string("Part2 Co-ordinates: ", !IO), part2(!IO), nl(!IO).
