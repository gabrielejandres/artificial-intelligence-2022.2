# 1. Modelagem
# Um tabuleiro N x N sera representado no programa atraves de um array de N elementos, onde em cada posicao i
# sera armazenado o numero correspondente a linha j em que a rainha esta presente na coluna i. Os indices irao
# variar de 0 ate N - 1.
# Por exemplo, o array [1, 3, 0, 2] representa o tabuleiro 4 X 4 onde a primeira rainha (coluna 0) esta na segunda
# linha, a segunda rainha (coluna 1) esta na quarta linha, a terceira rainha (coluna 2) esta na primeira
# linha e a quarta rainha (coluna 3) esta na terceira linha.
# OBS: INSERIR IMAGEM ILUSTRANDO O TABULEIRO DE EXEMPLO

# 2. a
import random
import numpy

def tabuleiro(tamTabuleiro, qntTabuleiros):
    tabuleiros = []
    for _ in range(qntTabuleiros):
        tab = []
        # Cria um tabuleiro
        for _ in range(tamTabuleiro):
            tab.append(random.randint(0, tamTabuleiro - 1))
        # Adiciona o novo tabuleiro a lista geral de tabuleiros
        tabuleiros.append(tab)

    return tabuleiros

# 2. b
def todosVizinhos(tabuleiro):
    vizinhos = []
    
    for indice in range(len(tabuleiro)):
        novoTabuleiro = tabuleiro   # todos os vizinhos devem ser obtidos a partir da configuracao atual
        rainha = novoTabuleiro[indice] # obtem a linha da rainha no indice indice

        # Obtem todas as opcoes de novas linhas para a rainha e substitui a posicao atual pelas novas para gerar todos os vizinhos possiveis
        for novaRainha in range(0, len(tabuleiro)):
            if rainha != novaRainha: # descarta a configuracao atual do tabuleiro
                novoTabuleiro[indice] = novaRainha
                vizinhos.append(novoTabuleiro)
            
    return vizinhos

# 2. c
def umVizinho(tabuleiro):
    vizinhos = todosVizinhos(tabuleiro)
    vizinhoAleatorio = random.randint(0, len(vizinhos) - 1)

    return vizinhos[vizinhoAleatorio]

# 2. d
def numeroAtaques(tabuleiro):
    ataques = 0
    dimensao = len(tabuleiro)
    
    for i in range(dimensao):
        for j in range(i + 1, dimensao):
            # Se as rainhas estao na mesma linha, elas se atacam
            if tabuleiro[i] == tabuleiro[j]:
                ataques += 1
            # Se as rainhas estao na mesma diagonal, elas se atacam
            elif abs(tabuleiro[i] - tabuleiro[j]) == abs(i - j):
                ataques += 1
                
    return ataques

# 5. b
def geraPopulacao(dimensaoIndividuo, qtdIndividuos): # dimensao sera o numero de rainhas (4, 8, 16, 32...)
    return tabuleiro(dimensaoIndividuo, qtdIndividuos)

# 5. c (operadores)

# maximo de ataques = (N * (N - 1)) / 2
# o valor maximo da funcao vai ser 1 que eh quando o valor dos ataques for 0
def calculaFitness(individuo):
    return 1 / (numeroAtaques(individuo) + 1)

# populacao = array de tabuleiros
def roletaViciada(populacao):
    proporcaoPorIndividuo = []
    totalAdaptacao = 0

    # calcula a soma total dos valores da funcao objetivo
    for individuo in populacao:
        totalAdaptacao += calculaFitness(individuo)

    # calcula a proporcao por individuo
    for individuo in populacao:
        proporcaoPorIndividuo[populacao.index(individuo)] = calculaFitness(individuo) / totalAdaptacao

    return proporcaoPorIndividuo 
 
# gera populacao intermediaria a partir da populacao
def selecao(populacao):
    proporcaoPorIndividuo = roletaViciada(populacao)
    tamanhoPopulacao = len(populacao)
    populacaoIntermediaria = []

    for _ in range(tamanhoPopulacao):
        individuoSorteado = numpy.random.choice(populacao, p = proporcaoPorIndividuo)  
        populacaoIntermediaria.append(individuoSorteado)

    return populacaoIntermediaria


def crossover(individuo1, individuo2):
    # escolhe um ponto aleatorio de corte
    pontoCorte = random.randint(0, len(individuo1) - 1)
    # cria os filhos
    filho1 = individuo1[0:pontoCorte] + individuo2[pontoCorte:]
    filho2 = individuo2[0:pontoCorte] + individuo1[pontoCorte:]

    return filho1, filho2
    
def mutacao(individuo):
    # escolhe um ponto aleatorio para mutacao
    pontoMutacao = random.randint(0, len(individuo) - 1)
    # escolhe uma nova linha aleatoria para a rainha
    novaLinha = random.randint(0, len(individuo) - 1)
    # realiza a mutacao
    individuo[pontoMutacao] = novaLinha

    return individuo

def AG(tamanhoPopulacao, numeroGeracoes, probCrossover, probMutacao, elitismo):
    populacao = geraPopulacao(4, tamanhoPopulacao)
    populacaoIntermediaria = []
    populacaoFinal = []
    geracao = 0

    while geracao < numeroGeracoes:
        # seleciona os individuos da populacao
        populacaoIntermediaria = selecao(populacao)
        # realiza o crossover
        for individuo1, individuo2 in zip(populacaoIntermediaria[0::2], populacaoIntermediaria[1::2]):
            # verifica se vai realizar o crossover
            if random.random() < probCrossover:
                filho1, filho2 = crossover(individuo1, individuo2)
                populacaoIntermediaria[populacaoIntermediaria.index(individuo1)] = filho1
                populacaoIntermediaria[populacaoIntermediaria.index(individuo2)] = filho2
        # realiza a mutacao
        for individuo in populacaoIntermediaria:
            # verifica se vai realizar a mutacao
            if random.random() < probMutacao:
                individuo = mutacao(individuo)
        # realiza o elitismo
        if elitismo:
            # ordena a populacao intermediaria de acordo com a funcao objetivo
            populacaoIntermediaria.sort(key = calculaFitness)
            # ordena a populacao final de acordo com a funcao objetivo
            populacaoFinal.sort(key = calculaFitness)
            # remove o pior individuo da populacao intermediaria
            populacaoIntermediaria.pop()
            # adiciona o melhor individuo da populacao final na populacao intermediaria
            populacaoIntermediaria.append(populacaoFinal[0])
        # atualiza a populacao final
        populacaoFinal = populacaoIntermediaria
        # atualiza a geracao
        geracao += 1

    return populacaoFinal

# Testes
if __name__ == '__main__':
    AG(10, 100, 0.7, 0.1, True)
    AG(10, 100, 0.7, 0.1, False)