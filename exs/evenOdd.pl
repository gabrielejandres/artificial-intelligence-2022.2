even([]).
even([_ | T]) :- odd(T).

odd([_]).
odd([_ | T]) :- even(T).