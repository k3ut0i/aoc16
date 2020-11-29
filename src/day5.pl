%% -*- mode : prolog -*-

% Hash of Prefix++Number must have atleast 5 zeros in hexadecimal form.
required_number(Prefix, Number, D) :-
    atom_concat(Prefix, Number, Data),
    md5_hash(Data, HashString, []),
    atom_chars(HashString, ['0', '0', '0', '0', '0', D | _]).

get_number(M, Prefix, Num-D) :-
    required_number(Prefix, M, D) -> M = Num;
    plus(1, M, M1), get_number(M1, Prefix, Num-D).

get_n_numbers(N, Prefix, Numbers) :-
    get_n_numbers_(N, 0, Prefix, Numbers). % start from zero
get_n_numbers_(0, _, _, []).
get_n_numbers_(N, M, Prefix, [D | Rest]) :-
    get_number(M, Prefix, Num-D), % try prefixes starting from M
    plus(1, N1, N), plus(1, Num, M1), % new prefix
    get_n_numbers_(N1, M1, Prefix, Rest).
        
req_num_2(Prefix, Number, Pos, D) :-
    atom_concat(Prefix, Number, Data),
    md5_hash(Data, HashString, []),
    atom_chars(HashString, ['0', '0', '0', '0', '0', D1, D | _]),
    atom_number(D1, Pos), Pos < 8.

get_number_2(M, Prefix, n(Num, Pos, D)) :-
    req_num_2(Prefix, M, Pos, D) -> M = Num;
    plus(1, M, M1), get_number_2(M1, Prefix, n(Num, Pos, D)).

get_eight_digits(Prefix, Digits) :-
    get_digits(0, [0, 1, 2, 3, 4, 5, 6, 7], Prefix, Digits).

get_digits(Start, Positions, Prefix, Digits) :-
    Positions = []
    -> Digits = []
    ;  get_number_2(Start, Prefix, n(Num, Pos, D)),
       (
	  select(Pos, Positions, RestPos)
       ->
          plus(Num, 1, NewStart),
	  get_digits(NewStart, RestPos, Prefix, DigitsRest),
	  Digits = [Pos-D | DigitsRest]
       ;
          plus(Num, 1, NewStart),
	  get_digits(NewStart, Positions, Prefix, Digits)
       ).

