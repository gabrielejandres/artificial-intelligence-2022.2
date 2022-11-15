max(X,Y,Max) :- X >= Y, Max is X.
max(X,Y,Max) :- X < Y, Max is Y.

maxlist([X], X).
maxlist([H|Tail], Max) :- maxlist(Tail, X), max(H, X, Max).