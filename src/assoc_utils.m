:- module(assoc_utils).
:- interface.
:- import_module assoc_list, pair.

:- pred compare_value(comparison_pred(V)::in(comparison_pred),
    comparison_pred(pair(K, V))::out(comparison_pred)) is det.
:- pred sort_by_value(comparison_pred(V)::in(comparison_pred),
    assoc_list(K,V)::in, assoc_list(K,V)::out) is det.

:- pred max_by_value(comparison_pred(V)::in(comparison_pred),
    assoc_list(K,V)::in, pair(K, V)::out) is semidet.
:- pred min_by_value(comparison_pred(V)::in(comparison_pred),
    assoc_list(K,V)::in, pair(K, V)::out) is semidet.

:- implementation.
:- import_module list.

compare_value(CV, CP) :-
    CP = (pred(P1::in , P2::in, C::out) is det :- call(CV, snd(P1), snd(P2), C)).

sort_by_value(CV, Ain, Aout) :-
    compare_value(CV, CP),
    sort(CP, Ain, Aout).

%% Stable order if values are equal
:- pred gt_kv(comparison_pred(V)::in(comparison_pred),
    pair(K, V)::in, pair(K, V)::in, pair(K, V)::out) is det.
gt_kv(CV, K1 - V1, K2 - V2, K3 - V3) :-
    call(CV, V2, V1, C),
    (
	C = (>) ->
	K3 = K2, V3 = V2
    ;
	K3 = K1, V3 = V1
    ).

max_by_value(CV, [A | AL], Max) :-
    foldl((pred(K::in, V::in, P1::in, P2::out) is det
	:- gt_kv(CV, pair(K,V), P1, P2)), AL, A, Max).


%% Stable order if values are equal
:- pred lt_kv(comparison_pred(V)::in(comparison_pred),
    pair(K, V)::in, pair(K, V)::in, pair(K, V)::out) is det.
lt_kv(CV, K1 - V1, K2 - V2, K3 - V3) :-
    call(CV, V2, V1, C),
    (
	C = (<) ->
	K3 = K2, V3 = V2
    ;
	K3 = K1, V3 = V1
    ).

min_by_value(CV, [A | AL], Min) :-
    foldl((pred(K::in, V::in, P1::in, P2::out) is det
	:- lt_kv(CV, pair(K,V), P1, P2)), AL, A, Min).
