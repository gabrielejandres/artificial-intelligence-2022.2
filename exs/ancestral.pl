parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).
parent(jim, karl).

ancestral(X, Y) :- parent(X, Y).
ancestral(X, Y) :- parent(X, Z), ancestral2(Z, Y).

ancestral2(X, Y) :- parent(X, Z), ancestral2(Z, Y).
ancestral2(X, Y) :- parent(X, Y).

ancestral3(X, Y) :- parent(X, Y).
ancestral3(X, Y) :- ancestral3(X, Z), parent(Z, Y).

ancestral4(X, Y) :- ancestral4(X, Z), parent(Z, Y).
ancestral4(X, Y) :- parent(X, Y).

ancestral5(X, Y) :- parent(X, Y).
ancestral5(X, Y) :- parent(Z, Y), ancestral5(X, Z).