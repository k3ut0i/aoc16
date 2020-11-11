:- module(day6).
:- interface.
:- import_module io.

:- pred part1and2(io::di, io::uo) is det.

:- implementation.
:- import_module file_utils, int_utils, list_utils, assoc_utils.
:- import_module int, list, assoc_list, char, pair, maybe, string.

:- pred empty_data(assoc_list(char, int)::out) is det.
empty_data(D) :-
    between_integers(97, 122, Ci), %% XXX between_integers is buggy
    map(det_from_int, remove_dups(Ci), Cs), %% Why am I getting dups?
    map(pred(C::in, pair(C, 0)::out) is det, Cs, D).

:- pred process_char(char::in, assoc_list(char, int)::in,
    assoc_list(char, int)::out) is semidet.
process_char(C, A1, A2) :-
    lookup(A1, C, N),
    update(C, N+1, A1, A2).

:- pred process_data(list(char)::in, assoc_list(char, int)::in,
    assoc_list(char, int)::out) is semidet.
process_data(Cs, A1, A2) :-
    foldl(process_char, Cs, A1, A2).

:- pred read_data(string::in, list(list(char))::out, io::di, io::uo) is det.
read_data(File, Xss, !IO) :-
    read_lines_from_file(File, LinesRes, !IO),
    (
	LinesRes = yes(Lines),
	map(pred(L::in, Cs::out) is det :- to_char_list(L, Cs), Lines, Tss),
	(transpose(Tss, Xss1) -> Xss = Xss1; Xss = [])
    ;
	LinesRes = no, Xss = []
    ).
:- pred compare_int(int::in, int::in, comparison_result::uo) is det.
compare_int(V1, V2, C) :- compare(C, V1, V2).

part1and2(!IO) :-
    read_data("../inputs/day6", Xss, !IO), empty_data(E),
    (
	map(pred(Cs::in, D::out) is semidet :- process_data(Cs, E, D),
	    Xss, Dss) ->
	(
	    map(max_by_value(compare_int), Dss, Ms1) ->
	    map(fst, Ms1, Chars1), from_char_list(Chars1, S1),
	    (
		map(min_by_value(compare_int), Dss, Ms2) ->
		map(fst, Ms2, Chars2), from_char_list(Chars2, S2),
		format("Part1: \'%s\', Part2: \'%s\'\n", [s(S1), s(S2)], !IO)
	    ;
		print("Failed finding min\n", !IO)
	    )
	;
	    print("Failed finding max\n", !IO)
	)
    ;
	print("Failed processing\n", !IO)
    ).

