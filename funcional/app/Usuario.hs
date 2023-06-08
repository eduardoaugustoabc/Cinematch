:- dynamic usuario/6.

% Definição da estrutura de dados para representar um usuário
usuario(
    generosFav(GenerosFav),
    diretoresFav(DiretoresFav),
    atoresFav(AtoresFav),
    filmesFav(FilmesFav),
    watchlist(Watchlist),
    filmesAssistidos(FilmesAssistidos)
).

% Função auxiliar para mostrar a representação textual de um usuário
mostrarUsuario(Usuario) :-
    writeln('----------------------------'),
    write('Gêneros Favoritos: '),
    writeln(Usuario.generosFav),
    write('Diretores Favoritos: '),
    writeln(Usuario.diretoresFav),
    write('Atores Favoritos: '),
    writeln(Usuario.atoresFav),
    write('Filmes Favoritos: '),
    writeln(Usuario.filmesFav),
    write('Watchlist: '),
    writeln(Usuario.watchlist),
    write('Filmes Assistidos: '),
    writeln(Usuario.filmesAssistidos),
    writeln('----------------------------').


% Adicionando informações de usuário como fatos
adicionarGenerosFav(Generos) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(GenerosFav, Generos, NovosGenerosFav),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(NovosGenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos))),
    writeln('Gêneros favoritos adicionados com sucesso!').

adicionarDiretoresFav(Diretores) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(DiretoresFav, Diretores, NovosDiretoresFav),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(GenerosFav), diretoresFav(NovosDiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos))),
    writeln('Diretores favoritos adicionados com sucesso!').

adicionarAtoresFav(Atores) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(AtoresFav, Atores, NovosAtoresFav),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(NovosAtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos))),
    writeln('Atores favoritos adicionados com sucesso!').

adicionarFilmesFav(Filmes) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(FilmesFav, Filmes, NovosFilmesFav),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(NovosFilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos))),
    writeln('Filmes favoritos adicionados com sucesso!').

adicionarFilmeNaWatchlist(Filme) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(Watchlist, [Filme], NovaWatchlist),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(NovaWatchlist), filmesAssistidos(FilmesAssistidos))),
    writeln('Filme adicionado à watchlist com sucesso!').

adicionarFilmeAssistido(Filme) :-
    usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(FilmesAssistidos)),
    append(FilmesAssistidos, [Filme], NovosFilmesAssistidos),
    retract(usuario(_, _, _, _, _, _)),
    assertz(usuario(generosFav(GenerosFav), diretoresFav(DiretoresFav), atoresFav(AtoresFav), filmesFav(FilmesFav), watchlist(Watchlist), filmesAssistidos(NovosFilmesAssistidos))),
    writeln('Filme adicionado à lista de filmes assistidos com sucesso!').