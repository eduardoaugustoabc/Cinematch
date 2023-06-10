:- consult('filme.pl').
:- consult('pesquisa.pl').
:- consult('usuario.pl').
:- consult('dashboard.pl').
:- consult('recomendacao.pl').

main :-
    lerJSON("./csvjson.json", Dados),
    cadastrarDados(Dados),
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
