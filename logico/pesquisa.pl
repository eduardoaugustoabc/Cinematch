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
    read_line_to_string(user_input, Cmd),
    (
        Cmd = "1" ->
            writeln('Digite o nome do filme:'),
            % read(user_input, Nome),
            pesquisarFilmesPorTitulo('A Origem', Filmes)
        ; Cmd = "2" ->
            writeln('Digite o gênero:'),
            read_line_to_string(user_input, Genero),
            pesquisarFilmesPorGenero(Genero, Filmes)
        ; Cmd = "3" ->
            writeln('Digite o ano:'),
            read_line_to_string(user_input, Ano),
            pesquisarFilmesPorDataLancamento(Ano, Filmes)
        ; Cmd = "4" ->
            writeln('Digite o Diretor:'),
            read_line_to_string(user_input, Diretor),
            pesquisarFilmesPorDiretor(Diretor, Filmes)
        ; Cmd = "5" ->
            writeln('Digite o Ator:'),
            read_line_to_string(user_input, Ator),
            pesquisarFilmesPorAtor(Ator, Filmes)
        ; writeln('Opção inválida.'),
          fail % falha para sair do predicado se a opção for inválida
    ).
