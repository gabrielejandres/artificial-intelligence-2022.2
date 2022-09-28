/*
    * Problema das Jarras - Tarefa 2
    * Busca Nao Informada - IA 2022.2
    * Gabriele Jandres Cavalcanti
    * DRE: 119159948
*/

% Auxiliar para retornar a diferenca entre duas listas. Dada uma lista L1 e outra L2, diferenca(L1, L2, L) retorna em L os 
% elementos que estao em L1 mas nao em L2
diferenca([], _, []).
diferenca([Head | Tail], L2, [Head | T]) :-
    not(member(Head, L2)), !,
    diferenca(Tail, L2, T).
diferenca([_ | Tail], L2, L) :-
    diferenca(Tail, L2, L).

/* 
    * a. Fato Prolog que representa o estado final do problema 
    * Predicado unario objetivo que especifica que na Jarra 1 temos que ter 2 litros, e na 
    2 nao importa quantos litros tenham, desde que seja menos do que 3 (capacidade maxima de J2)

    * Exemplo de consulta:
    * ?- objetivo([(0,0)]).
*/
objetivo((2, X)) :- 
    X =< 3.

/* 
    * b. Predicado ternario acao
    * acao((J1,J2),ACAO,(J1a,J2a)) transforma o estado das jarras (J1,J2) no estado (J1a,J2a) quando ACAO for executada
    * ACAO ∈ {encher1, encher2, esvaziar1, esvaziar2, passar12, passar21}

    * Exemplo de consulta:
    * ?- acao((0,0), encher1, (J1, J2)).
*/

% 1. Encher 
acao((J1, J2), encher1, (4, J2)) :-
    J1 < 4.     % enche Jarra 1 se ela tem menos de 4L
acao((J1, J2), encher2, (J1, 3)) :- 
    J2 < 3.     % enche Jarra 2 se ela tem menos de 3L

% 2. Esvaziar
acao((J1, J2), esvaziar1, (0, J2)) :- 
    J1 > 0.     % esvazia Jarra 1 se ela nao esta vazia
acao((J1, J2), esvaziar2, (J1, 0)) :- 
    J2 > 0.     % esvazia Jarra 2 se ela nao esta vazia

% 3. Passar
acao((J1, J2), passar12, (X, Y)) :- % Jarra 1 -> Jarra 2
    J1 > 0,                         % deve ter agua em J1
    J2 < 3,                         % J2 nao pode estar cheia
    X is max(J1 - (3 - J2), 0),     % so pode passar ate esvaziar J1
    Y is min(J1 + J2, 3).           % so pode passar ate encher J2

acao((J1, J2), passar21, (X, Y)) :- % Jarra 2 -> Jarra 1
    J2 > 0,                         % deve ter agua em J2
    J1 < 4,                         % J1 nao pode estar cheia
    X is min(J1 + J2, 4),           % so pode passar ate encher J1
    Y is max(J2 - (4 - J1), 0).     % so pode passar ate esvaziar J2

/* 
    * c. Predicado binario vizinho
    * Dada uma configuracao das jarras Node = (J1, J2) retorna todas as configuracoes possiveis que podemos obter aplicando cada uma das acoes 
    definidas acima ao estado representado por Node
    * Isto eh, queremos encontrar todos os filhos que, independente da acao executada, sejam obtidos a partir de Node

    * Exemplo de consulta:
    * ?- vizinhos((0,0), L).
*/

vizinhos(Node, Filhos) :-
    findall(Filho, acao(Node, _, Filho), Filhos).

/* 
    * d. Implementacao da Busca em Largura (BFS) utilizando vizinhos e objetivo
    * Versao 01: Sem imprimir o caminho e sem verificacao de nos repetidos

    * Exemplo de consulta:
    * ?- bfs_1([(0,0)]).
*/

% Auxiliar que retorna true se existir o fato objetivo com o no fornecido
eh_objetivo(Node) :- 
    objetivo(Node).    

% Auxiliar para adicionar os filhos no final da lista (fila) da fronteira
adiciona_fronteira(Filhos, F1, F2) :-
    append(F1, Filhos, F2).           

% Caso base da recursao: verifica se a cabeca da lista eh o objetivo
bfs_1([Node | _]) :- 
    eh_objetivo(Node).
% Caso recursivo: expande a cabeca da lista, adiciona os filhos no final da lista e chama a funcao novamente   
bfs_1([Node | F1]) :-                 
    vizinhos(Node, Filhos),                 % Obtem os vizinhos de Node        
    adiciona_fronteira(Filhos, F1, F2),     % Adiciona os vizinhos a fronteira do grafo
    bfs_1(F2).                              % Realiza a busca em largura na nova fila (com os novos nos adicionados)   

/* 

c. Faca uma consulta que represente a busca de uma solucao a partir do estado inicial (0,0). O que ocorre? Por que?
    Se fizermos uma consulta que represente a busca de uma solução a partir do estado inicial (0,0), isto eh, a consulta
    bfs_1([(0, 0)]), percebemos que o prolog sempre ira nos responder 'true', o que indica que sim, eh possivel encontrar alguma solucao
    a partir do estado inicial. E nao so alguma solucao, mas o prolog encontra infinitas solucoes. Como nao estamos eliminando estados 
    repetidos, novos filhos repetidos serao sempre adicionados na fila, o que faz o programa entrar em loop e responder 'true' indefinidamente. 
    Esse problema sera resolvido na versao 3 da bfs, onde os nos repetidos nao serao adicionados na fila.

*/                         

/* 
    * e. Adicao na busca da sequencia de configuracoes dos estados das jarras
    * Versao 02: Com caminho e sem verificacao de nos repetidos
    * O segundo parametro eh o responsavel por devolver o caminho ate o estado final

    * Exemplo de consulta:
    * ?- bfs_2([(0,0)], Caminho).
*/

% Caso base da recursao: verifica se a cabeca da lista eh o objetivo e adiciona node no caminho
bfs_2([Node | _], [Node]) :- 
    eh_objetivo(Node).
% Caso recursivo: expande a cabeca da lista, adiciona os filhos no final da lista e chama a funcao novamente   
bfs_2([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    adiciona_fronteira(Filhos, F1, F2),
    bfs_2(F2, Caminho).

/* 
    * f. Desconsiderar os nós que já foram gerados anteriormente ao acrescentar os elementos novos na fronteira
    * Versao 03: Com caminho e com verificacao de nos repetidos
    * O segundo parametro eh o responsavel por devolver o caminho ate o estado final

    * Exemplo de consulta:
    * ?- bfs([(0,0)], Caminho).
*/

% Alias para evitar que seja necessario passar a lista de nos visitados no terminal
bfs([Node | _], L) :- 
    bfs([Node], [Node], L).
% Caso base da recursao: verifica se a cabeca da lista eh o objetivo e adiciona node no caminho
bfs([Node | _], _, [Node]) :- 
    eh_objetivo(Node).
% Caso recursivo: expande a cabeca da lista, calcula a diferenca entre os nos visitados e os filhos do no atual,
% adiciona os filhos sem repeticoes no final da lista, atualiza os visitados e chama a funcao novamente   
bfs([Node | F1], Visitados, [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    diferenca(Filhos, Visitados, FilhosSemRepeticao),
    adiciona_fronteira(FilhosSemRepeticao, F1, F2),
    append(Visitados, FilhosSemRepeticao, VisitadosAtualizado),
    bfs(F2, VisitadosAtualizado, Caminho).

/* 
    * g. Repetir os exercicios anteriores para a busca em profundidade (DFS)
*/

/* 
    * Versao 01: Sem mostrar o caminho e com nos repetidos 

    * Exemplo de consulta:
    * ?- dfs_1([(2,0)]).    
*/

% Auxiliar para adicionar os filhos no inicio da lista da fronteira (pilha)
adiciona_fronteira_dfs(Filhos, F1, F2) :-
    append(Filhos, F1, F2).          

% Caso base da recursao: verifica se a cabeca da lista eh o objetivo
dfs_1([Node | _]) :- 
    eh_objetivo(Node).   
% Caso recursivo: expande a cabeca da lista, adiciona os filhos no inicio da lista e chama a funcao novamente  
dfs_1([Node | F1]) :-                 
    vizinhos(Node, Filhos),                     % Obtem os vizinhos de Node        
    adiciona_fronteira_dfs(Filhos, F1, F2),     % Adiciona os vizinhos a fronteira do grafo
    dfs_1(F2).                                  % Realiza a busca em profundidade na nova pilha (com os novos nos adicionados)                            

/* 
    * Versao 02: Mostrando o caminho e sem verificacao de nos repetidos 
    * O segundo parametro eh o responsavel por devolver o caminho ate o estado final

    * Exemplo de consulta:
    * ?- dfs_2([(0,0)], Caminho).   
*/

% Caso base da recursao: verifica se a cabeca da lista eh o objetivo e adiciona node no caminho
dfs_2([Node | _], [Node]) :- 
    eh_objetivo(Node).
% Caso recursivo: expande a cabeca da lista, adiciona os filhos no inicio da lista e chama a funcao novamente 
dfs_2([Node | F1], [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    reverse(Filhos, FilhosInvertidos), 
    adiciona_fronteira_dfs(FilhosInvertidos, F1, F2),
    dfs_2(F2, Caminho).

/* 
    * Versao 03: Mostrando o caminho e com verificacao de nos repetidos 
    * O segundo parametro eh o responsavel por devolver o caminho ate o estado final

    * Exemplo de consulta:
    * ?- dfs([(0,0)], Caminho).   
*/

% Alias para evitar que seja necessario passar a lista de nos visitados no terminal
dfs([Node | _], L) :- 
    dfs([Node], [Node], L).
% Caso base da recursao: verifica se a cabeca da lista eh o objetivo e adiciona node no caminho
dfs([Node | _], _, [Node]) :- 
    eh_objetivo(Node).
% Caso recursivo: expande a cabeca da lista, calcula a diferenca entre os nos visitados e os filhos do no atual,
% inverte a lista de filhos porque a ordem de geracao eh diferente da ordem de expansao, adiciona os filhos sem repeticoes no 
% inicio da lista, atualiza os visitados e chama a funcao novamente   
dfs([Node | F1], Visitados, [Node | Caminho]) :-
    vizinhos(Node, Filhos),
    diferenca(Filhos, Visitados, FilhosSemRepeticao),
    reverse(FilhosSemRepeticao, FilhosInvertidos), 
    adiciona_fronteira_dfs(FilhosInvertidos, F1, F2),
    append(FilhosSemRepeticao, Visitados, VisitadosAtualizado),
    dfs(F2, VisitadosAtualizado, Caminho).