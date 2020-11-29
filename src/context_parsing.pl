%% -*- mode: prolog -*-
%22abc => 2abc2abc => abcabcabcabc
:- use_module(library(dcg/basics)).

compressed([]) --> [].
compressed([X|Xs]) --> elem(X), compressed(Xs).

elem(m(S)) --> marker(Ss), {string_codes(S, Ss)}.
elem(s(S)) --> plain(Ss), {string_codes(S, Ss)}.

take(0, []) --> [].
take(N, [X | Xs]) -->
    {N>0, plus(N1, 1, N)}, [X], take(N1, Xs).

%% For part2 of the problem, I should use semicontext notation to
%% push back S into the incoming stream. Will do this in mercury
%% solution after I get more familiar with it.
marker(S) -->
    [0'(], digits(N1C), [0'x], digits(N2C), [0')],
    {number_codes(N1, N1C), number_codes(N2, N2C)},
    take(N1, Xs), {mult(N2, Xs, S)}.


plain([C|Cs]) --> [C], {char_type(C, upper)}, plain(Cs).
plain([]), [C] --> [C], {not(char_type(C, upper))}.
plain([]) --> [].

mult(N, S, Ss) :-
    mult(N, S, [], Ss).
mult(0, _, A, A).
mult(N, S, Acc, Ss) :-
    N > 0, plus(N1, 1, N), append(S, Acc, Acc1),
    mult(N1, S, Acc1, Ss).

cleanup([], "").
cleanup([m(X)|Xs], Xss) :- cleanup(Xs, Xss1), string_concat(X, Xss1, Xss).
cleanup([s(X)|Xs], Xss) :-
    cleanup(Xs, Xss1), string_concat(X, Xss1, Xss).

uncompress(S, U) :-
    string_codes(S, Cs),
    phrase(compressed(X), Cs), cleanup(X, U).

:- begin_tests(context_p).
test("advent") :- uncompress("ADVENT", "ADVENT"), !.
test("abc") :- uncompress("A(1x5)BC", "ABBBBBC"), !.
test("xyz") :- uncompress("(3x3)XYZ", "XYZXYZXYZ"), !.
test("abcdefg") :- uncompress("A(2x2)BCD(2x2)EFG", "ABCBCDEFEFG"), !.
test("a") :- uncompress("(6x1)(1x3)A", "(1x3)A"), !.
test("abcy") :- uncompress("X(8x2)(3x3)ABCY", "X(3x3)ABC(3x3)ABCY"), !.
test(final) :-
    open("../inputs/day9", read, Stream),
    read_line_to_codes(Stream, Line),
    phrase(compressed(X), Line), 
    cleanup(X, Y), string_length(Y, L),
    writeln(L),
    close(Stream).
:- end_tests(context_p).
