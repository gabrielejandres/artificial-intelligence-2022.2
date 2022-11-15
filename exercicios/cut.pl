split1([], [], []).
split1([H | Tail], P, N) :-
    H >= 0,
    P = [H | P1],
    split1(Tail, P1, N).
split1([H | Tail], P, N) :-
    H < 0,
    N = [H | N1],
    split1(Tail, P, N1).

split2([], [], []) :- !.
split2([H | Tail], P, N) :-
    H >= 0,
    !,
    P = [H | P1],
    split2(Tail, P1, N).
split2([H | Tail], P, N) :-
    N = [H | N1],
    split2(Tail, P, N1).