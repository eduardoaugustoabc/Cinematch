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
                ; member(Genero, GenerosFavoritos)
                ; member(Ator, AtoresFavoritos)
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
    % Lógica para calcular a nota de recomendação do filme
    % Aqui você pode definir sua própria lógica para atribuir a nota de recomendação

    % Exemplo: Atribuindo uma nota aleatória entre 1 e 10
    random_between(1, 10, NotaRecomendacao).

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
