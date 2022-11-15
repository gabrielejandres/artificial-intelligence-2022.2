unifiable([], _, []).

unifiable([H | T], Term, List) :-
    not(H = Term),
    unifiable(T, Term, List), !.

unifiable([H | T], Term, [H | List]) :-
    unifiable(T, Term, List).