:- module(filme, [
    mostrarFilme/1,
    getTituloFilme/2,
    getGenerosFilme/2,
    getDiretorFilme/2,
    getAtoresFilme/2,
    getDataFilme/2,
    getNotaImdbFilme/2,
    getNotaUsuario/2,
    getAtributos/2,
    adicionarFilme/0,
    adicionarFilmePorParametros/9,
    recuperarFilmePorTitulo/2,
    recuperarTodosFilmes/1,
    recuperaFilmePorTituloData/3,
    lerJSON/2
]).

% Definição de uma estrutura de dados para representar um filme
:- dynamic filme/9.
:- use_module(library(http/json)).

% Função auxiliar para mostrar a representação textual de um filme
mostrarFilme(Filme) :-
    writeln('----------------------------'),
    write('Título: '),
    writeln(Filme.titulo),
    write('Gêneros: '),
    writeln(Filme.generos),
    write('Descrição: '),
    writeln(Filme.descricao),
    write('Diretor: '),
    writeln(Filme.diretor),
    write('Atores: '),
    writeln(Filme.atores),
    write('Data de lançamento: '),
    writeln(Filme.dataLancamento),
    write('Duração: '),
    writeln(Filme.duracao),
    write('Nota do IMDB: '),
    writeln(Filme.notaImdb),
    write('Nota do usuário: '),
    writeln(Filme.notaUsuario),
    writeln('----------------------------').

% Gets de Filmes
getTituloFilme(Filme, Titulo) :-
    Titulo = Filme.titulo.

getGenerosFilme(Filme, Generos) :-
    Generos = Filme.generos.

getDiretorFilme(Filme, Diretor) :-
    Diretor = Filme.diretor.

getAtoresFilme(Filme, Atores) :-
    Atores = Filme.atores.

getDataFilme(Filme, Data) :-
    Data = Filme.dataLancamento.

getNotaImdbFilme(Filme, Nota) :-
    Nota = Filme.notaImdb.

getNotaUsuario(Filme, Nota) :-
    Nota = Filme.notaUsuario.

getAtributos(Filme, Atributos) :-
    Atributos = [Filme.titulo, Filme.generos, Filme.descricao, Filme.diretor, Filme.atores, Filme.dataLancamento, Filme.duracao, Filme.notaImdb, Filme.notaUsuario].

% Adicionando filmes como fatos
adicionarFilme :-
    write('Título: '),
    read_line_to_string(user_input, Titulo),
    write('Data de lançamento: '),
    catch(read_line_to_string(user_input, DataLancamento), _, fail),

    % Verifica se a data é um inteiro não negativo
    (
        verificaEhInteiroNaoNegativo(DataLancamento) ->
            true
        ;
            writeln('A data de lançamento deve ser um número inteiro não negativo.'),
            writeln('--------Digites os dados NOVAMENTE--------'),
            adicionarFilme  % Chama novamente o predicado para continuar a execução
    ),

    write('Gêneros (separados por vírgula): '),
    read_line_to_string(user_input, GenerosString),
    atomic_list_concat(Generos, ',', GenerosString),
    write('Descrição: '),
    read_line_to_string(user_input, Descricao),
    write('Diretor: '),
    read_line_to_string(user_input, Diretor),
    write('Atores (separados por vírgula): '),
    read_line_to_string(user_input, AtoresString),
    atomic_list_concat(Atores, ',', AtoresString),
    write('Duração: '),
    read_line_to_string(user_input, Duracao),
    
    % Verifica se a duração é um inteiro não negativo
    (
        verificaEhInteiroNaoNegativo(Duracao) ->
            true
        ;
            writeln('A duração deve ser um número inteiro não negativo.'),
            writeln('--------Digites os dados NOVAMENTE--------'),
            adicionarFilme  % Chama novamente o predicado para continuar a execução
    ),
    write('Nota do IMDb: '),
    read_line_to_string(user_input, NotaImdb),
    
    % Verifica se a nota imdb é um inteiro não negativo
    (
        verificaEhInteiroNaoNegativo(NotaImdb) ->
            true
        ;
            writeln('A Nota do IMDB deve ser um número inteiro não negativo.'),
            writeln('--------Digites os dados NOVAMENTE--------'),
            adicionarFilme  % Chama novamente o predicado para continuar a execução
    ),
    write('Nota do usuário: '),
    read_line_to_string(user_input, NotaUsuario),

    % Verifica se a nota do usuário é um inteiro não negativo
    (
        verificaEhInteiroNaoNegativo(NotaUsuario) ->
            true
        ;
            writeln('A Nota do Usuário deve ser um número inteiro não negativo.'),
            writeln('--------Digites os dados NOVAMENTE--------'),
            adicionarFilme  % Chama novamente o predicado para continuar a execução
    ),
    
    ObjetoJSON = json{titulo:Titulo, generos:GenerosString, descricao:Descricao, diretor:Diretor, atores:AtoresString, lancamento:DataLancamento, duracao:Duracao, nimdb:NotaImdb, nuser:NotaUsuario},
    open("novosdados.json", read, ReadStream),
    json_read_dict(ReadStream, JSONExistente),
    close(ReadStream),
    write(JSONExistente),
    write(ObjetoJSON),
    append(JSONExistente,[ObjetoJSON],NovoJSON), 
    write(NovoJSON),
    open("novosdados.json", write, WriteStream),
    json_write_dict(WriteStream, NovoJSON),
    close(WriteStream),

    assertz(filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario)),
    writeln('Filme adicionado com sucesso!').
    
verificaEhInteiroNaoNegativo(Input) :-
    atom_string(AtomInput, Input),
    atom_number(AtomInput, Number),
    integer(Number),
    Number >= 0.

adicionarFilmePorParametros(Titulo, [H|_], Descricao, Diretor, [Atores|_], DataLancamento, Duracao, NotaImdb, NotaUsuario) :-
    atomic_list_concat(Parts, ',', H),
    atomic_list_concat(Natores, ',', Atores),
    assertz(filme(Titulo, Parts, Descricao, Diretor, Natores, DataLancamento, Duracao, NotaImdb, NotaUsuario)).
    
% Recuperando Filmes
recuperarFilmePorTitulo(Titulo, Filme) :-
    filme(Titulo, Generos, Descricao, Diretor, Atores, DataLancamento, Duracao, NotaImdb, NotaUsuario),
    Filme = filme{
        titulo: Titulo,
        generos: Generos,
        descricao: Descricao,
        diretor: Diretor,
        atores: Atores,
        dataLancamento: DataLancamento,
        duracao: Duracao,
        notaImdb: NotaImdb,
        notaUsuario: NotaUsuario
    }.

recuperarTodosFilmes(Filmes) :-
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

recuperaFilmePorTituloData(Titulo, DataLancamento, Filme) :-
    filme(Titulo, _, _, _, _, DataLancamento, _, _, _),
    recuperarFilmePorTitulo(Titulo, Filme).


lerJSON(FilePath, File) :-
    open(FilePath, read, F),
    json_read_dict(F, File).
