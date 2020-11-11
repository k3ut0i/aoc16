:- module(day7).
:- interface.
:- import_module io.

:- pred part1and2(io::di, io::uo) is det.

:- implementation.
:- import_module list, string, char, maybe.
:- import_module file_utils, list_utils.

:- type ip ---> ip(normal::list(string), hyper::list(string)).

:- pred split_alternative(list(T)::in, list(T)::out, list(T)::out) is det.
split_alternative([], [], []).
split_alternative([A], [A], []).
split_alternative([A1, A2 | As], [A1 | As1], [A2 | As2]) :-
    split_alternative(As, As1, As2).

:- pred parse_ip(string::in, ip::out) is det.
parse_ip(S, ip(Normal, Hyper)) :-
    words_separator((pred(C::in) is semidet :- C = '['; C = ']'), S) = Ss,
    split_alternative(Ss, Normal, Hyper).

:- pred abba_list(list(char)::in) is semidet.
abba_list([X, Y, Y, X|_]) :- not(X=Y).
abba_list([_|Tail]) :- abba_list(Tail).

:- pred string_to_chars(string::in, list(char)::out) is det.
string_to_chars(S, to_char_list(S)).

:- pred aba_list(list(char)::in, char::out, char::out) is nondet.
aba_list([X, Y, X|_], X, Y).
aba_list([_|Rest], X, Y) :- aba_list(Rest, X, Y).

:- pred aba(list(list(char))::in, char::out, char::out) is nondet.
aba(Css, X, Y) :- member(Cs, Css), aba_list(Cs, X, Y).

:- pred ssl_ip(ip::in) is semidet.
ssl_ip(ip(Ss, Hs)) :-
    map(string_to_chars, Ss, Sss),
    map(string_to_chars, Hs, Hss),
    aba(Sss, X, Y), aba(Hss, Y, X).

:- pred tls_ip(ip::in) is semidet.
tls_ip(ip(Ns, Hs)) :-
    map(string_to_chars, Ns, Nss),
    map(string_to_chars, Hs, Hss),
    some_list(abba_list, Nss),
    all_list(pred(X::in) is semidet :- not(abba_list(X)), Hss).

part1and2(!IO) :-
    read_lines_from_file("../inputs/day7", LinesRes, !IO),
    (
	LinesRes = yes(Lines),
	map(parse_ip, Lines, IPs),
	filter(tls_ip, IPs, TLS),
	filter(ssl_ip, IPs, SSL),
	length(TLS, L1), length(SSL, L2),
	format("TLS IP: %i, SSL IP: %i\n", [i(L1), i(L2)], !IO)
    ;
	LinesRes = no, print("Couldn't Read File\n", !IO)
    ).
