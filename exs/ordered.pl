ordered([]).
ordered([_]).
ordered([X, Y | Tail]) :- ordered([Y | Tail]), X =< Y.