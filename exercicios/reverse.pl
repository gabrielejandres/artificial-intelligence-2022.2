conc([], L, L).
conc([X | L1], L2, [X | L3]) :- conc(L1, L2, L3).

rev([], []).
rev([H | Tail], List) :- rev(Tail, L1), conc(L1, [H], List).