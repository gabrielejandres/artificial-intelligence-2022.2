subset([], []).
subset([H | Tail], [H | Tail1]) :- subset(Tail, Tail1).
subset([_ | Tail], Subset) :- subset(Tail, Subset).

sumlist([X], X).
sumlist([H | Tail], Sum) :- sumlist(Tail, S), Sum is H + S.

subsum(Set, Sum, Subset) :- subset(Set, Subset), sumlist(Subset, S), S =:= Sum.