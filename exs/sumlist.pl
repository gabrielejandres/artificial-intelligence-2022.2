sumlist([X], X).
sumlist([H | Tail], Sum) :- sumlist(Tail, S), Sum is H + S.