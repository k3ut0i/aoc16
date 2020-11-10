:- module(day4).
:- interface.
:- import_module io.

:- pred part1(io::di, io::uo) is det.
:- pred part2(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string, int, maybe, assoc_list, char, pair.
:- import_module file_utils.

:- type entry ---> entry(list(string), int, string).

:- pred count_char(list(char)::in, assoc_list(char, int)::in,
    assoc_list(char, int)::out) is det.
count_char([], A, A).
count_char([C | Cs], Ain, Aout):-
    (
	search(Ain, C, N) ->
	(
	    update(C, N+1, Ain, AT1) -> AT = AT1
	;
	    AT = [pair(C, N+1) | Ain]
	)
    ;
	AT = [pair(C, 1) | Ain]
    ),
	count_char(Cs, AT, Aout).

%% XXX WHY SHOULD I specify snd(P1) is of type int?
 :- pred compare_value(pair(char, int)::in, pair(char, int)::in,
     comparison_result::uo) is det.
compare_value(P1, P2, V) :-
    compare(V1, snd(P1) : int, snd(P2) : int),
    (
	V1 = (=) -> %in ascending order of letters is reverse.
	compare(V, fst(P2) : char, fst(P1) : char)
    ;
	V1 = V
    ).

:- pred sort_by_value(assoc_list(char, int)::in, assoc_list(char, int)::out) is det.
sort_by_value(Ain, Aout) :- sort(compare_value, Ain, Aout).

:- pred check_sum(list(string)::in, string::out) is det.
check_sum(Ss, A) :-
    map((pred(S::in, Chars::out) is det :- to_char_list(S, Chars)), Ss, Css),
    foldl((pred(S::in, A1::in, A2::out) is det :- append(A1,S,A2)), Css, [], Cs),
    count_char(Cs, [], Aunsorted),
    sort_by_value(Aunsorted, Asorted),
    det_take(5, reverse(Asorted), A5),
    from_char_list(keys(A5), A).
    
    
:- pred parse_entry(string::in, entry::out) is semidet.
parse_entry(S, entry(Name, SecId, CheckSum)) :-
    split_at_char('-', S) = Ss,
    split_last(Ss, Name, Last),
    words_separator((pred(C::in) is semidet :- C = '['; C = ']'),Last)
    = [SecStr, CheckSum],
    to_int(SecStr, SecId).


:- pred get_all_entries(string::in, maybe(list(entry))::out, io::di, io::uo) is det.
get_all_entries(File, Es, !IO) :-
    read_lines_from_file(File, LinesRes, !IO),
    (
	LinesRes = yes(Lines),
	% Need a better way to write if_not Goal then Something
	    (map(parse_entry, Lines, Es1) -> Es = yes(Es1); Es = no)
    ;
	LinesRes = no, Es = no
    ).

:- pred real_room(entry::in) is semidet.
real_room(entry(Names, _, CheckSum)) :-
    check_sum(Names, CheckSum).

part1(!IO) :-
    get_all_entries("../inputs/day4", Es, !IO),
    (
	Es = yes(Entries),
	filter(real_room, Entries, ValidEntries),
	foldl((pred(entry(_, S, _)::in, Ain::in, Aout::out) is det :- Aout = Ain+S),
	    ValidEntries, 0, N),
	print(N, !IO), nl(!IO)
%	write_list(Entries, "\n", print, !IO)
    ;
	Es = no , print("Failed to get entries\n", !IO)
    ).

:- pred shift_right(int::in, char::in, char::out) is det.
shift_right(N, Ci, Co) :-
    Ni = to_int(Ci),
    (
	Ni =< 90 ->
	Ni1 = Ni - 65 + N, Nir = Ni1 mod 26,
	No = Nir + 65, det_from_int(No, Co)
    ;
	Ni1 = Ni - 97 + N, Nir = Ni1 mod 26,
	No = Nir + 97, det_from_int(No, Co)
    ).

:- pred decrypt_name(int::in, string::in, string::out) is det.
decrypt_name(N, Si, So) :-
    to_char_list(Si, Ci), 
    map(shift_right(N), Ci, Co),
    from_char_list(Co, So).

:- pred decrypt_entry(entry::in, entry::out) is det.
decrypt_entry(entry(N1, Sid, C), entry(N2, Sid, C)) :-
    map(decrypt_name(Sid), N1, N2).

part2(!IO) :-
    get_all_entries("../inputs/day4", Es, !IO),
    (
	Es = yes(Entries),
	filter(real_room, Entries, ValidEntries),
	map(decrypt_entry, ValidEntries, Decrypted),
	(
	    find_first_match((pred(entry(N, _, _)::in) is semidet :- head(N) = "northpole"),
		Decrypted, M) ->
	    print(M, !IO), nl(!IO)
	;
	    print("Couldn't find northpole\n", !IO)
	)
    ;
	Es = no , print("Failed to get entries\n", !IO)
    ).

% part2(!IO) :-
%     Rec = "qzmt-zixmtkozy-ivhz-343[abcde]",
%     (
% 	parse_entry(Rec, E) ->
% 	decrypt_entry(E, D), print(D, !IO), nl(!IO)
%     ;
% 	print("Failed parse\n", !IO)
%     ).
