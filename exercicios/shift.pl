conc([], L, L).
conc([X | L1], L2, [X | L3]) :- conc(L1, L2, L3).

shif([H | Tail], List2) :- conc(Tail, [H], List2).