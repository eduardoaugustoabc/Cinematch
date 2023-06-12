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
    opcoes.

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

% Função responsavel por exibir e receber (input) a opção do usuário sobre o que ele deseja usar da aplicação. Instancia acoes com o valor recebido.
opcoes:-
  writeln('++---------------------Escolha uma ação----------------------++'),
  writeln('1- Pesquisar'),
  writeln('2- Favoritar Gênero'),
  writeln('3- Favoritar Ator'),
  writeln('4- Favoritar Diretor'),
  writeln('5- Favoritar Filme'),
  writeln('6- Desfavoritar Filme'),
  writeln('7- Recomendação'),
  writeln('8- Adicionar filme assistido'),
  writeln('9- Adicionar a lista de desejos'),
  writeln('10- Lista de diretores favoritos'),
  writeln('11- Lista de filmes que se deseja assistir'),
  writeln('12- Lista de generos favoritos'),
  writeln('13- Lista de atores favoritos'),
  writeln('14- Lista de filmes favoritos'),
  writeln('15- Lista de filmes assistidos'),
  writeln('16- Cadastrar Filme'),
  writeln('17- Dashboard'),
  writeln('18- Desfavoritar Gênero'),
  writeln('19- Desfavoritar Ator'),
  writeln('20- Desfavoritar Diretor'),
  writeln('21- EXIT PROGRAM'),
  writeln('++-----------------------------------------------------------++'),
  acoes.

acoes:-
    writeln('Opção escolhida : '), 
    read_line_to_string(user_input, CmdString),
    atom_number(CmdString, Cmd),
    (
        Cmd = 1 ->
            selecaoPesquisa(Filmes),
            percorrerFilmes(Filmes),
            opcoes
        ; Cmd = 2 ->
            writeln('Qual gênero deseja favoritar : Action, Adventure, Horror, Animation, Fantasy, Comedy, Biography, Drama, Family, History, Sci-Fi, Thriller, Mystery, Crime, Western, Romance, War, Musical, Music, Sport'),
            read_line_to_string(user_input, GeneroInput),
            atom_string(Genero, GeneroInput),
            adicionarGeneroFavorito(Genero),
            recuperarGenerosFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 3 ->
            writeln('Qual ator deseja favoritar :'),
            read_line_to_string(user_input, AtorInput),
            atom_string(Ator, AtorInput),
            adicionarAtorFavorito(Ator),
            recuperarAtoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 4 ->
            writeln('Qual diretor deseja favoritar :'),
            read_line_to_string(user_input, DiretorInput),
            atom_string(Diretor, DiretorInput),
            adicionarDiretorFavorito(Diretor),
            recuperarDiretoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 5 ->
            writeln('Qual o título do Filme que deseja favoritar :'),
            read_line_to_string(user_input, FilmeInput),
            atom_string(Filme, FilmeInput),
            writeln('Qual a data de lançamento do Filme que deseja desfavoritar : '),
            read_line_to_string(user_input, DataInput),
            atom_string(Data, DataInput),
            adicionarFilmeFavorito(Filme, Data),
            recuperarFilmesFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 6 ->
            writeln('Qual o título do Filme que deseja desfavoritar : '),
            read_line_to_string(user_input, FilmeInput),
            atom_string(Filme, FilmeInput),
            writeln('Qual a data de lançamento do Filme que deseja desfavoritar : '),
            read_line_to_string(user_input, DataInput),
            atom_string(Data, DataInput),
            removerFilmeFavorito(Filme, Data),
            recuperarFilmesFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 7 ->
            recomendarFilmesComNota(Recomendacoes),
            percorrerFilmes(Recomendacoes),
            opcoes
        ; Cmd = 8 ->
            writeln('Qual o título do Filme que deseja adicionar a lista de assistidos : '),
            read_line_to_string(user_input, FilmeInput),
            atom_string(Filme, FilmeInput),
            writeln('Qual a data de lançamento do Filme que deseja adicionar a lista de assistidos : '),
            read_line_to_string(user_input, DataInput),
            atom_string(Data, DataInput),
            adicionarFilmeAssistido(Filme, Data),
            recuperarFilmesAssistidos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 9 ->
            writeln('Qual o título do Filme que deseja adicionar a lista de desejos : '),
            read_line_to_string(user_input, FilmeInput),
            atom_string(Filme, FilmeInput),
            writeln('Qual a data de lançamento do Filme que deseja adicionar a lista de desejos : '),
            read_line_to_string(user_input, DataInput),
            atom_string(Data, DataInput),
            adicionarFilmeWatchlist(Filme, Data),
            recuperarFilmesWatchlist(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 10 ->
            recuperarDiretoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 11 ->
            recuperarFilmesWatchlist(Filmes),
            percorreFilmesFav(Filmes, FilmesOrganizados),
            percorrerFilmes(FilmesOrganizados),
            opcoes
        ; Cmd = 12 ->
            recuperarGenerosFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 13 ->
            recuperarAtoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 14 ->
            recuperarFilmesFavoritos(Filmes),
            percorreFilmesFav(Filmes, FilmesOrganizados),
             percorrerFilmes(FilmesOrganizados),
            opcoes
        ; Cmd = 15 ->
            recuperarFilmesAssistidos(Filmes),
            percorreFilmesFav(Filmes, FilmesOrganizados),
            percorrerFilmes(FilmesOrganizados),
            writeln(Filmes),
            opcoes
        ; Cmd = 16 ->
            adicionarFilme,
            opcoes
        ; Cmd = 17 ->
            dashboardString,
            opcoes
        ; Cmd = 18 ->
            writeln('Qual gênero deseja desfavoritar: '),
            read_line_to_string(user_input, GenInput),
            atom_string(Genero, GenInput),
            removerGeneroFavorito(Genero),
            recuperarGenerosFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 19 ->
            writeln('Qual ator deseja desfavoritar: '),
            read_line_to_string(user_input, AtorInput),
            atom_string(Ator, AtorInput),
            removerAtorFavorito(Ator),
            recuperarAtoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 20 ->
            writeln('Qual diretor deseja desfavoritar: '),
            read_line_to_string(user_input, DirInput),
            atom_string(Diretor, DirInput),
            removerDiretorFavorito(Diretor),
            recuperarDiretoresFavoritos(Filmes),
            writeln(Filmes),
            opcoes
        ; Cmd = 21 ->
            writeln('++---------------------Escolha uma ação----------------------++'),
            writeln('      Obrigado por usar o CINEMATCH         '),
            writeln('++---------------------Escolha uma ação----------------------++')
        ; writeln('Opção inválida.'),
          fail % falha para sair do predicado se a opção for inválida
    ).

percorreFilmesFav([[Titulo|[Data|_]]|[]],Filmes):- 
    atom_string(Titulo, TituloInput),
    atom_number(Data,DataInput),
    pesquisarFilmesPorTituloeData(TituloInput,DataInput,Filmes).
percorreFilmesFav([[Titulo|[Data|_]]|T],FilmesF):-
    percorreFilmesFav(T,Final),
    atom_string(Titulo, TituloInput),
    pesquisarFilmesPorTituloeData(TituloInput,Data,Filmes),
    append(Filmes,Final,FilmesF).
