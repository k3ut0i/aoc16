:- module(test_day1).
:- interface.
:- import_module(io).
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module maybe, string, list, pair, day1.

% main(!IO) :- read_line_from_file("../inputs/day1", X, !IO),
% (
%     X = yes(S),
%     (
% 	read_instr(S, Is) ->
% 	write_list(Is, "\n", write_instr, !IO);
% 	% write_list(words_separator(comma_space, S),
% 	    % 	 "\n",write_string, !IO)
% 	write_string("Failed Instr", !IO)
%     )
% ;		 
%     X = no, write_string("Failed Reading", !IO)
% ).

:- pred part1(io::di, io::uo) is det.
part1(!IO) :-
    read_instr_from_file("../inputs/day1", Ls2, !IO),
    (
	calculate_end(Ls2, X - Y)
	->
	write_int(X, !IO),
	write_string(" ", !IO),
	write_int(Y, !IO),
	nl(!IO)
    ;
	write_string("Failed Calculate", !IO)
    ).

:- pred part2(io::di, io::uo) is det.
part2(!IO) :-
    read_instr_from_file("../inputs/day1", Ls, !IO),
    (
	calculate_trail(Ls, Ts)
	->
	flesh_trail(Ts, Tss1),
	remove_adjacent_dups(Tss1, Tss),
%	write_list(Tss, "\n", print, !IO)
	(
	    find_first_dup(Tss, P)
	    ->
	    print(P, !IO), nl(!IO)
	;
	    write_string("Failed finding repeat point", !IO)
	)
    ;
	write_string("Failed Trail print", !IO)
    ).

main(!IO) :-
    write_string("End point is: ", !IO), part1(!IO),
    write_string("First repeat point is: ", !IO), part2(!IO).
