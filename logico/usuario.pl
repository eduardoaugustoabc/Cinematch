:- module(usuario, [
    adicionarDiretorFavorito/1,
    removerDiretorFavorito/1,
    recuperarDiretoresFavoritos/1,
    adicionarGeneroFavorito/1,
    removerGeneroFavorito/1,
    recuperarGenerosFavoritos/1,
    adicionarAtorFavorito/1,
    removerAtorFavorito/1,
    recuperarAtoresFavoritos/1,
    adicionarFilmeFavorito/2,
    removerFilmeFavorito/2,
    recuperarFilmesFavoritos/1,
    adicionarFilmeWatchlist/2,
    removerFilmeWatchlist/2,
    recuperarFilmesWatchlist/1,
    adicionarFilmeAssistido/2,
    removerFilmeAssistido/2,
    recuperarFilmesAssistidos/1
]).

:- dynamic diretorFavorito/1.
:- dynamic generoFavorito/1.
:- dynamic atorFavorito/1.
:- dynamic filmeFavorito/2.
:- dynamic watchlist/2.
:- dynamic filmesAssistidos/2.

% Adicionar diretor favorito
adicionarDiretorFavorito(Diretor) :-
    assertz(diretorFavorito(Diretor)),
    writeln('Diretor favorito adicionado com sucesso!').

% Remover diretor favorito
removerDiretorFavorito(Diretor) :-
    retractall(diretorFavorito(Diretor)),
    writeln('Diretor favorito removido com sucesso!').

recuperarDiretoresFavoritos(Diretores) :-
    findall(Diretor, diretorFavorito(Diretor), Diretores).

% Adicionar gênero favorito
adicionarGeneroFavorito(Genero) :-
    assertz(generoFavorito(Genero)),
    writeln('Gênero favorito adicionado com sucesso!').

% Remover gênero favorito
removerGeneroFavorito(Genero) :-
    retractall(generoFavorito(Genero)),
    writeln('Gênero favorito removido com sucesso!').

% Recuperar todos os gêneros favoritos
recuperarGenerosFavoritos(Generos) :-
    findall(Genero, generoFavorito(Genero), Generos).

% Adicionar ator favorito
adicionarAtorFavorito(Ator) :-
    assertz(atorFavorito(Ator)),
    writeln('Ator favorito adicionado com sucesso!').

% Remover ator favorito
removerAtorFavorito(Ator) :-
    retractall(atorFavorito(Ator)),
    writeln('Ator favorito removido com sucesso!').

% Recuperar todos os atores favoritos
recuperarAtoresFavoritos(Atores) :-
    findall(Ator, atorFavorito(Ator), Atores).

% Adicionar filme favorito
adicionarFilmeFavorito(Titulo, DataLancamento) :-
    assertz(filmeFavorito(Titulo, DataLancamento)),
    writeln('Filme favorito adicionado com sucesso!').

% Remover filme favorito
removerFilmeFavorito(Titulo, DataLancamento) :-
    retractall(filmeFavorito(Titulo, DataLancamento)),
    writeln('Filme favorito removido com sucesso!').

% Recuperar todos os filmes favoritos
recuperarFilmesFavoritos(Filmes) :-
    findall([Titulo, DataLancamento], filmeFavorito(Titulo, DataLancamento), Filmes).

% Adicionar filme à lista de desejos
adicionarFilmeWatchlist(Titulo, DataLancamento) :-
    assertz(watchlist(Titulo, DataLancamento)),
    writeln('Filme adicionado à lista de desejos com sucesso!').

% Remover filme da lista de desejos
removerFilmeWatchlist(Titulo, DataLancamento) :-
    retractall(watchlist(Titulo, DataLancamento)),
    writeln('Filme removido da lista de desejos com sucesso!').

% Recuperar todos os filmes da lista de desejos
recuperarFilmesWatchlist(Filmes) :-
    findall([Titulo, DataLancamento], watchlist(Titulo, DataLancamento), Filmes).


% Adicionar filme à lista de filmes assistidos
adicionarFilmeAssistido(Titulo, DataLancamento) :-
    assertz(filmesAssistidos(Titulo, DataLancamento)),
    writeln('Filme adicionado à lista de filmes assistidos com sucesso!').

% Remover filme da lista de filmes assistidos
removerFilmeAssistido(Titulo, DataLancamento) :-
    retractall(filmesAssistidos(Titulo, DataLancamento)),
    writeln('Filme removido da lista de filmes assistidos com sucesso!').

% Recuperar todos os filmes da lista de filmes assistidos
recuperarFilmesAssistidos(Filmes) :-
    findall([Titulo, DataLancamento], filmesAssistidos(Titulo, DataLancamento), Filmes).
