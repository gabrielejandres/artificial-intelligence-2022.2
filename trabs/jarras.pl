/* 
    * a. Fato Prolog que representa o estado final do problema
    * Objetivo: Na Jarra 1 temos que ter 2 litros, e na 2 nao importa quantos litros tenham
*/
objetivo((2, _)).

/* 
    * b. Predicado ternario acao((J1,J2),ACAO,(J1a,J2a)) que transforma o estado das jarras (J1,J2) no estado (J1a,J2a) quando a acao for executada
    * ACAO ∈ {encher1, encher2, esvaziar1, esvaziar2, passar12, passar21}) for executada.
*/

% Encher 
acao((J1, J2), encher1, (4, J2)) :- J1 < 4. % Jarra 1
acao((J1, J2), encher2, (J1, 3)) :- J2 < 3. % Jarra 2

% Esvaziar
acao((J1, J2), esvaziar1, (0, J2)) :- J1 > 0. % Jarra 1
acao((J1, J2), esvaziar2, (J1, 0)) :- J2 > 0. % Jarra 2

% Passar
acao((J1, J2), passar12, (X, Y)) :- % Jarra 1 -> Jarra 2
    J1 > 0,                         % deve ter agua em J1
    J2 < 3,                         % J2 nao pode estar cheia
    X is max(J1 - (3 - J2), 0),     % so pode passar ate esvaziar J1
    Y is min(J1 + J2, 3).           % so pode passar ate encher J2

acao((21, J2), passar21, (X, Y)) :- % Jarra 2 -> Jarra 1
    J2 > 0,                         % deve ter agua em J2
    J1 < 4,                         % J1 nao pode estar cheia
    X is min(J1 + J2, 4),           % so pode passar ate encher J1
    Y is max(J2 - (4 - J1), 0).     % so pode passar ate esvaziar J2

/* 
    * c. Predicado binario vizinho(N, FilhosN) que dado uma configuracao das jarras N retorna todas as configuracoes possiveis que podemos obter aplicando cada uma das acoes definidas acima ao estado representado por N
*/

vizinhos(N, FilhosN) :-
    findall(Filho, acao(N, _, Filho), FilhosN). % queremos encontrar todos os filhos que, independente da acao executada, sejam obtidos a partir de N


/* 
    * d. Implementacao da Busca em Largura (BFS) utilizando vizinhos e objetivo
*/

is_goal(Node) :- 
    objetivo(Node).    % Retorna true se existir o fato objetivo com o no fornecido

add_to_frontier(Filhos, F1, F2) :-
    append(F1, Filhos, F2).           % Adiciona os filhos no final da fila da fronteira

bfs_1([Node | _]) :- is_goal(Node).   % Caso base da recursao: verifica se a cabeca da lista eh o objetivo

bfs_1([Node | F1]) :-                 % Caso recursivo: expande a cabeca da lista
    vizinhos(Node, Filhos),             % Obtem os vizinhos de Node        
    add_to_frontier(Filhos, F1, F2),    % Adiciona os vizinhos a fronteira do grafo
    bfs_1(F2).                        % Realiza a busca em largura na nova fila (com os novos nos adicionados)                            

/* 
    * e. Adicao na busca da sequencia de configuracoes dos estados das jarras
*/

bfs_2([Node | _], [Node | _]) :- is_goal(Node).

bfs_2([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    add_to_frontier(Filhos, F1, F2),
    bfs_2(F2, Caminho).

/* 
    * f. Desconsiderar os nós que já foram gerados anteriormente ao acrescentar os elementos novos na fronteira
*/

diferenca([], _, []).

diferenca([Head | Tail], L2, [Head | T]) :-
    not(member(Head, L2)),
    diferenca(Tail, L2, T), !.

diferenca([_ | Tail], L2, L) :-
    diferenca(Tail, L2, L).

calc_diferenca(L1, L2, L) :-
    diferenca(L1, L2, X),
    diferenca(L2, L1, Y),
    append(X, Y, L).

add_to_frontier_2(Filhos, F1, F2) :-
    calc_diferenca(Filhos, F1, F2).

bfs([Node | _], [Node | _]) :- is_goal(Node).

bfs([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    add_to_frontier_2(Filhos, F1, F2),
    bfs(F2, Caminho).

/* 
    * g. Repetir os exercicios anteriores para a busca em profundidade (DFS)
*/

% Versao 01: Sem mostrar o caminho e com nos repetidos

add_to_frontier_dfs(Filhos, F1, F2) :-
    append(Filhos, F1, F2).           % Adiciona os filhos no inicio da lista da fronteira (pilha)

dfs_1([Node | _]) :- is_goal(Node).   % Caso base da recursao: verifica se a cabeca da lista eh o objetivo

dfs_1([Node | F1]) :-                 % Caso recursivo: expande a cabeca da lista
    vizinhos(Node, Filhos),             % Obtem os vizinhos de Node        
    add_to_frontier_dfs(Filhos, F1, F2),    % Adiciona os vizinhos a fronteira do grafo
    dfs_1(F2).                        % Realiza a busca em profundidade na nova pilha (com os novos nos adicionados)                            

% Versao 02: Mostrando o caminho e com nos repetidos

dfs_2([Node | _], [Node | _]) :- is_goal(Node).

dfs_2([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    add_to_frontier_dfs(Filhos, F1, F2),
    dfs_2(F2, Caminho).

% Versao 03: Mostrando o caminho e sem nos repetidos

add_to_frontier_dfs_2(Filhos, F1, F2) :-
    calc_diferenca(Filhos, F1, F2).

dfs([Node | _], [Node | _]) :- is_goal(Node).

dfs([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    add_to_frontier_dfs_2(Filhos, F1, F2),
    dfs(F2, Caminho).