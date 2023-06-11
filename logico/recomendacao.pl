:- module(recomendacao, [recomendarFilmesComNota/1]).

recomendarFilmesComNota(Recomendacoes) :-
    recuperarTodosFilmes(Filmes),
    recuperarDiretoresFavoritos(DiretoresFavoritos),
    recuperarGenerosFavoritos(GenerosFavoritos),
    recuperarAtoresFavoritos(AtoresFavoritos),

    findall(
        filme{
            titulo: Titulo,
            generos: Generos,
            descricao: Descricao,
            diretor: Diretor,
            atores: Atores,
            dataLancamento: DataLancamento,
            duracao: Duracao,
            notaImdb: NotaImdb,
            notaUsuario: NotaUsuario
        },
        (
            member(Filme, Filmes),
            Filme = filme{
                titulo: Titulo,
                generos: Generos,
                descricao: Descricao,
                diretor: Diretor,
                atores: Atores,
                dataLancamento: DataLancamento,
                duracao: Duracao,
                notaImdb: NotaImdb,
                notaUsuario: NotaUsuario
            },
            (
                member(Diretor, DiretoresFavoritos)
                ; member(_, GenerosFavoritos)
                ; member(_, AtoresFavoritos)
            )
        ),
        FilmesRelevantes
    ),

    calcularNotasRecomendacao(FilmesRelevantes, FilmesComNota),
    ordenarFilmesPorNotaRecomendacao(FilmesComNota, FilmesOrdenados),
    formatarRecomendacoes(FilmesOrdenados, 5, Recomendacoes).

% Função para calcular a nota de recomendação para cada filme
calcularNotasRecomendacao([], []).
calcularNotasRecomendacao([Filme | FilmesRestantes], [FilmeComNota | FilmesComNotaRestantes]) :-
    calcularNotaRecomendacao(Filme, NotaRecomendacao),
    FilmeComNota = Filme.put(notaRecomendacao, NotaRecomendacao),
    calcularNotasRecomendacao(FilmesRestantes, FilmesComNotaRestantes).

% Função para calcular a nota de recomendação de um filme
calcularNotaRecomendacao(Filme, NotaRecomendacao) :-
    Filme = filme{
        titulo: _,
        generos: Generos,
        descricao: _,
        diretor: _,
        atores: Atores,
        dataLancamento: _,
        duracao: _,
        notaImdb: NotaImdb,
        notaUsuario: NotaUsuario
    },

    recuperarGenerosFavoritos(GenerosFavoritos),
    recuperarAtoresFavoritos(AtoresFavoritos),

    % Define os pesos para a media ponderada
    PesoImdb is 3,
    PesoUsuario is 6,

    countInArray(Generos, GenerosFavoritos, CountGeneros),
    PesoGeneros is CountGeneros * 1.5,

    countInArray(Atores, AtoresFavoritos, CountAtores),
    PesoAtores is CountAtores * 0.5,

    % Calcula a nota de recomendação usando a media ponderada
    NotaRecomendacao is (NotaImdb * PesoImdb) + (NotaUsuario * PesoUsuario) + PesoGeneros + PesoAtores.

% Função auxiliar para contar a ocorrência de um elemento em uma lista
countInArray([], _, 0).
countInArray([X|Resto], Array, Count) :-
    member(X, Array),
    countInArray(Resto, Array, CountResto),
    Count is CountResto + 1.
countInArray([_|Resto], Array, Count) :-
    countInArray(Resto, Array, Count).

% Função auxiliar para ordenar os filmes por nota de recomendação
ordenarFilmesPorNotaRecomendacao(Filmes, FilmesOrdenados) :-
    predsort(compararNotaRecomendacao, Filmes, FilmesOrdenados).

% Função auxiliar para comparar a nota de recomendação de dois filmes
compararNotaRecomendacao(Resultado, Filme1, Filme2) :-
    (   Filme1.notaRecomendacao < Filme2.notaRecomendacao ->
        Resultado = '>'
    ;   Filme1.notaRecomendacao > Filme2.notaRecomendacao ->
        Resultado = '<'
    ;   Resultado = '='
    ).

% Função auxiliar para formatar as recomendações
formatarRecomendacoes([], _, []).
formatarRecomendacoes(_, 0, []).
formatarRecomendacoes([Filme | FilmesRestantes], N, [Recomendacao | RecomendacoesRestantes]) :-
    Recomendacao = Filme.put(notaRecomendacao, Filme.notaRecomendacao),
    N1 is N - 1,
    formatarRecomendacoes(FilmesRestantes, N1, RecomendacoesRestantes).