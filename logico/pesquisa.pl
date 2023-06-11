:- module(pesquisa, [
    pesquisarFilmesPorTitulo/2,
    pesquisarFilmesPorDiretor/2,
    pesquisarFilmesPorDataLancamento/2,
    pesquisarFilmesPorAtor/2,
    pesquisarFilmesPorGenero/2,
    selecaoPesquisa/1
]).

% Método usado para pesquisar determinado filme por seu nome
pesquisarFilmesPorTitulo(Titulo, Filmes) :-
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
        filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
        Filmes
    ).

% Método usado para pesquisar determinado filme por seu diretor
pesquisarFilmesPorDiretor(Diretor, Filmes) :-
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
        filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
        Filmes
    ).

% Método usado para pesquisar determinado filme por sua data de lancamento
pesquisarFilmesPorDataLancamento(DataLancamento, Filmes) :-
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
        filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
        Filmes
    ).

% Método usado para pesquisar determinado filme por um de seus atores
% Método usado para pesquisar determinado filme por um de seus atores
pesquisarFilmesPorAtor(Ator, Filmes) :-
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
            filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
            member(Ator, Atores)
        ),
        Filmes
    ).

% Método usado para pesquisar determinado filme por um de seus gêneros
pesquisarFilmesPorGenero(Genero, Filmes) :-
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
            filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
            member(Genero, Generos)
        ),
        Filmes
    ).

selecaoPesquisa(Filmes) :-
    writeln('Digite o número de acordo com a pesquisa que deseja fazer:'),
    writeln('1) Nome'),
    writeln('2) Gênero'),
    writeln('3) Ano'),
    writeln('4) Diretor'),
    writeln('5) Ator'),
    writeln('Qual sua escolha: '),
    read_line_to_string(user_input, CmdString),
    atom_number(CmdString, Cmd),
    (
        Cmd = 1 ->
            writeln('Digite o nome do filme:'),
            read_line_to_string(user_input, Nome),
            pesquisarFilmesPorTitulo(Nome, Filmes)
        ; Cmd = 2 ->
            writeln('Digite o gênero:'),
            read_line_to_string(user_input, NomeInput),
            atom_string(Genero, NomeInput),
            pesquisarFilmesPorGenero(Genero, Filmes)
        ; Cmd = 3 ->
            writeln('Digite o ano:'),
            read_line_to_string(user_input, String),
            number_string(Ano, String),
            pesquisarFilmesPorDataLancamento(Ano, Filmes)
        ; Cmd = 4 ->
            writeln('Digite o Diretor:'),
            read_line_to_string(user_input, Diretor),
            pesquisarFilmesPorDiretor(Diretor, Filmes)
        ; Cmd = 5 ->
            writeln('Digite o Ator:'),
            read_line_to_string(user_input, NomeInput),
            atom_string(Ator, NomeInput),
            pesquisarFilmesPorAtor(Ator, Filmes)
        ; writeln('Opção inválida.'),
          fail % falha para sair do predicado se a opção for inválida
    ).