:- use_module('./filme.pl').
:- use_module('./pesquisa.pl').
:- use_module('./dashboard.pl').
:- use_module('./usuario.pl').
:- use_module('./recomendacao.pl').

main :-
    lerJSON("./csvjson.json", Dados),
    cadastrarDados(Dados),
    lerJSON("./novosdados.json", Persistencia),
    cadastrarDados(Persistencia),
    selecaoPesquisa(Filmes2),
    percorrerFilmes(Filmes2),
    main.

percorrerFilmes([]).
percorrerFilmes([Filme|Resto]) :-
    mostrarFilme(Filme),
    percorrerFilmes(Resto).

cadastrarDados([]).
cadastrarDados([H|T]) :-
    atom_string(H.titulo, Ntitulo),
    atom_string(H.diretor, Ndiretor),
    adicionarFilmePorParametros(Ntitulo, [H.generos], H.descricao, Ndiretor, [H.atores], H.lancamento, H.duracao, H.nimdb, H.nuser),
    cadastrarDados(T).
