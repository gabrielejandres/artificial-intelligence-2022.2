conc([], L, L).
conc([X | L1], L2, [X | L3]) :- conc(L1, L2, L3).

means(0, zero).
means(1, one).
means(2, two).
means(3, three).
means(4, four).
means(5, five).
means(6, six).
means(7, seven).
means(8, eight).
means(9, nine).

translate([], []).
translate([H | Tail], List2) :- means(H, T), translate(Tail, L2), conc([T], L2, List2).