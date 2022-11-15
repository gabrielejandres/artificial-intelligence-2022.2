bet(N1, N2, X) :- N1 =< N2, X is N2.
bet(N1, N2, X) :- N2 >= N1, Aux is N2 - 1, bet(N1, Aux, X).