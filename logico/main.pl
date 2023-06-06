:- consult('filme.pl').


main :-
    adicionarFilme,
    adicionarFilme,
    recuperarTodosFilmes(Filmes),
    percorrerFilmes(Filmes),
    write("Ok").

percorrerFilmes([]).
percorrerFilmes([Filme | Resto]) :-
    % getAtributos(Filme,Titulo),
    % writeln(Titulo),
    mostrarFilme(Filme),
    percorrerFilmes(Resto).