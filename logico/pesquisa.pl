% Método usado para pesquisar determinado filme pelo seu diretor
pesquisaPorDiretor(Filmes, Diretor, Resultado) :-
    include(mesmoDiretor(Diretor), Filmes, Resultado),
    Resultado \= [].

mesmoDiretor(Diretor, Filme) :-
    getDiretorFilme(Filme, Diretor).

% Método usado para pesquisar determinado filme por um de seus atores
pesquisaPorAtor(Filmes, Ator, Resultado) :-
    include(mesmoAtor(Ator), Filmes, Resultado),
    Resultado \= [].

mesmoAtor(Ator, Filme) :-
    getAtoresFilme(Filme, Atores),
    member(Ator, Atores).

% Método usado para adequar a pesquisa de acordo com o quê o usuário quer; funciona como
% algumas funcionalidades do main e trata exceções, como opções inválidas
selecaoPesquisa(Rep) :-
    writeln('Digite o número de acordo com a pesquisa que deseja fazer:'),
    writeln('1) Nome'),
    writeln('2) Gênero'),
    writeln('3) Ano'),
    writeln('4) Diretor'),
    writeln('5) Ator'),
    writeln('Qual sua escolha: '),
    read_line_to_string(user_input, Cmd),
    filmes(Rep, Filmes),
    (
        Cmd = "1" ->
            writeln('Digite o nome do filme:'),
            read_line_to_string(user_input, Nome),
            pesquisaPorNome(Filmes, Nome, Resultado),
            (
                Resultado = [] ->
                    writeln('Nenhum filme encontrado.')
                ;
                    maplist(writeln, Resultado)
            )
        ; Cmd = "2" ->
            writeln('Digite o gênero:'),
            read_line_to_string(user_input, Genero),
            pesquisaPorGenero(Filmes, Genero, Resultado),
            (
                Resultado = [] ->
                    writeln('Nenhum filme encontrado.')
                ;
                    maplist(writeln, Resultado)
            )
        ; Cmd = "3" ->
            writeln('Digite o ano:'),
            read_line_to_string(user_input, Ano),
            pesquisaPorAno(Filmes, Ano, Resultado),
            (
                Resultado = [] ->
                    writeln('Nenhum filme encontrado.')
                ;
                    maplist(writeln, Resultado)
            )
        ; Cmd = "4" ->
            writeln('Digite o Diretor:'),
            read_line_to_string(user_input, Diretor),
            pesquisaPorDiretor(Filmes, Diretor, Resultado),
            (
                Resultado = [] ->
                    writeln('Nenhum filme encontrado.')
                ;
                    maplist(writeln, Resultado)
            )
        ; Cmd = "5" ->
            writeln('Digite o Ator:'),
            read_line_to_string(user_input, Ator),
            pesquisaPorAtor(Filmes, Ator, Resultado),
            (
                Resultado = [] ->
                    writeln('Nenhum filme encontrado.')
                ;
                    maplist(writeln, Resultado)
            )
        ; writeln('Opção inválida.')
    ).
