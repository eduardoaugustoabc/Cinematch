:- use_module(library(pairs)).
:- dynamic diretorFavorito/1.
:- dynamic generoFavorito/1.
:- dynamic atorFavorito/1.
:- dynamic filmeFavorito/2.
:- dynamic watchlist/2.
:- dynamic filmesAssistidos/2.

% Recupera a quantidade de filmes assistidos
quantidadeFilmesAssistidos(Quantidade) :-
    findall(_, filmesAssistidos(_, _), Filmes),
    length(Filmes, Quantidade).

% Recupera os gêneros dos filmes assistidos pelo usuário
generosMaisAssistidos(Generos) :-
    recuperarFilmesAssistidos(Filmes),
    recuperarGenerosFilmes(Filmes, Generos).

% Recupera os gêneros dos filmes
recuperarGenerosFilmes(Filmes, Generos) :-
    findall(Genero, (
        member([Titulo, DataLancamento], Filmes),
        recuperaFilmePorTituloData(Titulo, DataLancamento, FilmeData),
        getAtributos(FilmeData, [_, GenerosFilme|_]),
        member(Genero, GenerosFilme)
    ), Generos).






mediaNotasFilmesAssistidos(Media) :-
    recuperarFilmesAssistidos(Filmes),
    recuperarNotasFilmes(Filmes, Notas),
    calcularMedia(Notas, Media).

recuperarNotasFilmes(Filmes, Notas) :-
    findall(Nota, (
        member([Titulo, DataLancamento], Filmes),
        recuperaFilmePorTituloData(Titulo, DataLancamento, FilmeData),
        getNotaUsuario(FilmeData, Nota)
    ), Notas).

calcularMedia(Notas, Media) :-
    somaNotas(Notas, Soma),
    length(Notas, Quantidade),
    (Quantidade > 0
    ->  Media is Soma / Quantidade
    ;   Media = 0
    ).

somaNotas([], 0).
somaNotas([Nota|Notas], Soma) :-
    somaNotas(Notas, SomaRestante),
    Soma is Nota + SomaRestante.




mediaGenero :-
    writeln('+ Média Dos Filmes Assistidos por Gêneros :'),
    recuperarFilmesAssistidos(Filmes),
    recuperarGenerosFilmes(Filmes, Generos),
    calcularMediaPorGeneros(Generos).

calcularMediaPorGeneros([]).
calcularMediaPorGeneros([Genero|Resto]) :- 
    pesquisarFilmesPorGenero(Genero,Filmes),
    getNotasGenero(Filmes, Notas),
    calcularMedia(Notas, Media), 
    write('    - '),write(Genero),write(' = '),format('~2f', Media),writeln(''),
    calcularMediaPorGeneros(Resto).

getNotasGenero([], []).
getNotasGenero([FilmeData|RestoFilmes], [Nota|RestoNotas]) :-
    getNotaUsuario(FilmeData, Nota),
    getNotasGenero(RestoFilmes, RestoNotas).








% Gera a string do dashboard
dashboardString :-
    quantidadeFilmesAssistidos(QuantidadeFilmes),
    generosMaisAssistidos(Generos),
    mediaNotasFilmesAssistidos(Media),
    writeln('----------------------------------------------------'),
    writeln('                     DASHBOARD                      '),
    writeln('----------------------------------------------------'),
    write('+ Total de Filmes Assistdos : '),writeln(QuantidadeFilmes),
    write('+ Generos Assistidos : '),writeln(Generos),
    write('+ Média Filmes Assistidos : '),writeln(Media),
    mediaGenero,
    writeln('----------------------------------------------------').

% Formata a lista de médias de notas por gênero
formatMediaNotasGeneros([]).
formatMediaNotasGeneros([(Genero, Media)|T]) :-
    format("    ~w: ~2f\n", [Genero, Media]),
    formatMediaNotasGeneros(T).
