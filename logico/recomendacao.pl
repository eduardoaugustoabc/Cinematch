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
                ; member(Gen, GenerosFavoritos), member(Gen, Generos)
                ; member(Ator, AtoresFavoritos), member(Ator, Atores)
            )
        ),
        FilmesRelevantes
    ),

    calcularNotasRecomendacao(FilmesRelevantes, FilmesComNota),
    ordenarFilmesPorNotaRecomendacao(FilmesComNota, FilmesOrdenados),
    formatarRecomendacoes(FilmesOrdenados, 5, Recomendacoes).

calcularNotasRecomendacao([], []).
calcularNotasRecomendacao([Filme | FilmesRestantes], [FilmeComNota | FilmesComNotaRestantes]) :-
    calcularNotaRecomendacao(Filme, NotaRecomendacao),
    FilmeComNota = Filme.put(notaRecomendacao, NotaRecomendacao),
    calcularNotasRecomendacao(FilmesRestantes, FilmesComNotaRestantes).

% Função para calcular a nota de recomendação de um filme (aleatoriamente)
calcularNotaRecomendacao(Filme, NotaRecomendacao) :-
    random_between(0, 10, NotaRecomendacao).

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
