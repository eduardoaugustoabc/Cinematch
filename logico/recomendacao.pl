:- dynamic filme/9.

% Predicado para atribuir uma nota ao filme com base nas preferências do usuário
atribuiNota(Filme, GenerosFavoritos, DiretoresFavoritos, AtoresFavoritos, Nota) :-
    filme{
        titulo: _,
        generos: Generos,
        descricao: _,
        diretor: Diretor,
        atores: Atores,
        dataLancamento: _,
        duracao: _,
        notaImdb: _,
        notaUsuario: _
    } = Filme,
    intersect(GenerosFavoritos, Generos, GenerosIntersectados),
    length(GenerosIntersectados, NumGenerosIntersectados),
    length(GenerosFavoritos, NumGenerosFavoritos),
    (
        NumGenerosFavoritos > 0,
        GeneroScore is NumGenerosIntersectados / NumGenerosFavoritos
    ;
        GeneroScore is 0
    ),
    member(Diretor, DiretoresFavoritos),
    DiretorScore is 1,
    intersect(AtoresFavoritos, Atores, AtoresIntersectados),
    length(AtoresIntersectados, NumAtoresIntersectados),
    length(AtoresFavoritos, NumAtoresFavoritos),
    (
        NumAtoresFavoritos > 0,
        AtorScore is NumAtoresIntersectados / NumAtoresFavoritos
    ;
        AtorScore is 0
    ),
    Nota is GeneroScore + DiretorScore + AtorScore.

% Predicado para recomendar uma quantidade de filmes com base nas preferências do usuário
recomenda(Quantidade, FilmesRecomendados) :-
    recuperarTodosFilmes(FilmesRepositorio),
    recuperarGenerosFavoritos(GenerosFavoritos),
    recuperarDiretoresFavoritos(DiretoresFavoritos),
    recuperarAtoresFavoritos(AtoresFavoritos),
    findall(
        Filme,
        (
            member(Filme, FilmesRepositorio),
            \+ filmeFavorito(Filme.titulo, Filme.dataLancamento),
            atribuiNota(Filme, GenerosFavoritos, DiretoresFavoritos, AtoresFavoritos, Nota),
            Filme = Filme{notaUsuario: Nota}
        ),
        FilmesNaoRecomendados
    ),
    predsort(compareFilmes, FilmesNaoRecomendados, FilmesOrdenados),
    filtrarRecomendados(FilmesOrdenados, [], FilmesRecomendados),
    length(FilmesRecomendados, NumFilmesRecomendados),
    min(Quantidade, NumFilmesRecomendados, NumFilmesRecomendadosReais),
    take(NumFilmesRecomendadosReais, FilmesRecomendados, FilmesRecomendados).

% Função auxiliar para comparar filmes com base na nota do usuário
compareFilmes(Order, Filme1, Filme2) :-
    (
        Filme1.notaUsuario < Filme2.notaUsuario,
        Order = <
    ;
        Filme1.notaUsuario > Filme2.notaUsuario,
        Order = >
    ;
        Order = =
    ).

% Função auxiliar para filtrar os filmes recomendados
filtrarRecomendados([], FilmesRecomendados, FilmesRecomendados).
filtrarRecomendados([Filme|Filmes], FilmesRecomendadosParcial, FilmesRecomendados) :-
    (
        \+ member(Filme, FilmesRecomendadosParcial),
        append(FilmesRecomendadosParcial, [Filme], FilmesRecomendadosAtualizado)
    ;
        FilmesRecomendadosAtualizado = FilmesRecomendadosParcial
    ),
    filtrarRecomendados(Filmes, FilmesRecomendadosAtualizado, FilmesRecomendados).

% Função auxiliar para obter os primeiros N elementos de uma lista
take(N, _, Xs) :- N =< 0, !, N =:= 0, Xs = [].
take(_, [], []).
take(N0, [X|Xs], [X|Ys]) :- N0 > 0, N is N0 - 1, take(N, Xs, Ys).

% Função auxiliar para obter o mínimo entre dois valores
min(X, Y, X) :- X =< Y.
min(X, Y, Y) :- X > Y.

% Função auxiliar para encontrar a interseção de duas listas
intersect([], _, []).
intersect([X|Xs], Ys, [X|Zs]) :- member(X, Ys), intersect(Xs, Ys, Zs).
intersect([X|Xs], Ys, Zs) :- \+ member(X, Ys), intersect(Xs, Ys, Zs).
