% Módulo Usuario

:- dynamic usuario/1.

% Definição do fato usuário
usuario(
    generosFav(Genres),
    diretoresFav(Directors),
    atoresFav(Actors),
    filmesFav(FavoriteMovies),
    watchlist(Watchlist),
    filmesAssistidos(WatchedMovies)
).

% Regras para obter os valores de um usuário
getWatch(Usuario, Watchlist) :-
    usuario(_, _, _, _, Watchlist, _).

getGeneros(Usuario, Genres) :-
    usuario(Genres, _, _, _, _, _).

getDiretores(Usuario, Directors) :-
    usuario(_, Directors, _, _, _, _).

getAtores(Usuario, Actors) :-
    usuario(_, _, Actors, _, _, _).

getFilmesFav(Usuario, FavoriteMovies) :-
    usuario(_, _, _, FavoriteMovies, _, _).

getFilmesAssistidos(Usuario, WatchedMovies) :-
    usuario(_, _, _, _, _, WatchedMovies).

% Regras para adicionar e remover filmes da watchlist
addWatch(Usuario, Filme, NovoUsuario) :-
    getWatch(Usuario, Watchlist),
    \+ member(Filme, Watchlist),
    append(Watchlist, [Filme], NovaWatchlist),
    retract(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, WatchedMovies)),
    assert(usuario(Genres, Directors, Actors, FavoriteMovies, NovaWatchlist, WatchedMovies)),
    NovoUsuario = usuario(Genres, Directors, Actors, FavoriteMovies, NovaWatchlist, WatchedMovies).

removeWatch(Usuario, Filme, NovoUsuario) :-
    getWatch(Usuario, Watchlist),
    member(Filme, Watchlist),
    delete(Watchlist, Filme, NovaWatchlist),
    retract(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, WatchedMovies)),
    assert(usuario(Genres, Directors, Actors, FavoriteMovies, NovaWatchlist, WatchedMovies)),
    NovoUsuario = usuario(Genres, Directors, Actors, FavoriteMovies, NovaWatchlist, WatchedMovies).

% Regras para adicionar e remover filmes da lista de filmes assistidos
addAssistidos(Usuario, Filme, NovoUsuario) :-
    getFilmesAssistidos(Usuario, WatchedMovies),
    \+ member(Filme, WatchedMovies),
    append(WatchedMovies, [Filme], NovaWatchedMovies),
    retract(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, WatchedMovies)),
    assert(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, NovaWatchedMovies)),
    NovoUsuario = usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, NovaWatchedMovies).

removeAssistidos(Usuario, Filme, NovoUsuario) :-
    getFilmesAssistidos(Usuario, WatchedMovies),
    member(Filme, WatchedMovies),
    delete(WatchedMovies, Filme, NovaWatchedMovies),
    retract(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, WatchedMovies)),
    assert(usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, NovaWatchedMovies)),
    NovoUsuario = usuario(Genres, Directors, Actors, FavoriteMovies, Watchlist, NovaWatchedMovies).

% Regras para adicionar e remover filmes da lista de filmes favoritos
favoritarFilme(Usuario, Filme, NovoUsuario) :-
    getFilmesFav(Usuario,
