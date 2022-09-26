subset([], []).
subset([H | Tail], [H | Tail1]) :- subset(Tail, Tail1).
subset([_ | Tail], Subset) :- subset(Tail, Subset).