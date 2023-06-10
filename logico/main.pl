:- consult('filme.pl').
:- consult('pesquisa.pl').
:- consult('usuario.pl').
:- consult('dashboard.pl').
:- consult('recomendacao.pl').

main :-
    lerJSON("./csvjson.json", Dados),
    cadastrarDados(Dados),
    lerJSON("./novosdados.json", Persistencia),
    cadastrarDados(Persistencia),
    % filmes criados para testes
    adicionarFilmePorParametros('O Poderoso Chefão', ['Crime', 'Drama'], 'Um chefão da máfia luta para manter seu império.', 'Francis Ford Coppola', ['Marlon Brando', 'Al Pacino', 'James Caan'], 1972, 175, 9.2, 9.1),
    adicionarFilmePorParametros('Interestelar', ['Ficção científica', 'Drama'], 'Um grupo de astronautas viaja através de um buraco de minhoca em busca de um novo planeta para habitar.', 'Christopher Nolan', ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'], 2002, 169, 8.6, 8.5),
    adicionarFilmePorParametros('Matrix', ['Ação', 'Ficção científica'], 'Um hacker descobre que a realidade em que vive é uma simulação criada por máquinas.', 'Lana Wachowski', ['Keanu Reeves', 'Laurence Fishburne', 'Carrie-Anne Moss'], 1999, 136, 8.7, 8.8),
    adicionarFilmePorParametros('O Senhor dos Anéis: A Sociedade do Anel', ['Aventura', 'Fantasia'], 'Um grupo de heróis se une para destruir um poderoso anel e salvar a Terra Média.', 'Peter Jackson', ['Elijah Wood', 'Ian McKellen', 'Viggo Mortensen'], 2002, 178, 8.8, 8.7),
    adicionarFilmePorParametros('A Origem', ['Ação', 'Ficção científica'], 'Um grupo de ladrões especializados invade os sonhos das pessoas para extrair informações valiosas.', 'Hayao Miyazaki', ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Elliot Page'], 2010, 148, 8.8, 8.7),
    adicionarFilmePorParametros('Pulp Fiction', ['Crime', 'Drama'], 'Histórias interligadas retratando o submundo do crime em Los Angeles.', 'Quentin Tarantino', ['John Travolta', 'Samuel L. Jackson', 'Uma Thurman'], 1994, 154, 8.9, 8.8),
    adicionarFilmePorParametros('A Origem', ['Drama'], 'Um homem descontente cria um clube de luta clandestino como forma de escape da sua vida monótona.', 'Hayao Miyazaki', ['Brad Pitt', 'Edward Norton', 'Helena Bonham Carter'], 1999, 139, 8.8, 8.7),
    adicionarFilmePorParametros('O Labirinto do Fauno', ['Fantasia', 'Drama'], 'Uma garota escapa para um mundo fantástico durante a Guerra Civil Espanhola.', 'Guillermo del Toro', ['Ivana Baquero', 'Sergi López', 'Leandro Firmino', 'Maribel Verdú'], 2006, 118, 8.2, 8.4),
    adicionarFilmePorParametros('Cidade de Deus', ['Crime', 'Drama'], 'A história de diversos personagens envolvidos no crime organizado em uma favela do Rio de Janeiro.', 'Fernando Meirelles', ['Alexandre Rodrigues', 'Leandro Firmino', 'Phellipe Haagensen'], 2002, 130, 8.6, 8.5),
    adicionarFilmePorParametros('A Viagem de Chihiro', ['Animação', 'Aventura'], 'Uma menina se aventura em um mundo mágico para resgatar seus pais transformados em porcos.', 'Hayao Miyazaki', ['Rumi Hiiragi', 'Miyu Irino', 'Mari Natsuki'], 2001, 125, 8.6, 8.5),
    pesquisarFilmesPorTitulo('A Origem',Filmes),
    percorrerFilmes(Filmes).



percorrerFilmes([]).
percorrerFilmes([Filme|Resto]) :-
    mostrarFilme(Filme),
    percorrerFilmes(Resto).


cadastrarDados([]).
cadastrarDados([H|T]) :-
    atom_string(H.titulo, Ntitulo),
    atom_string(H.diretor, Ndiretor),
    adicionarFilmePorParametros([Ntitulo], [H.generos], H.descricao, [Ndiretor], [H.atores], H.lancamento, H.duracao, H.nimdb, H.nuser),
    cadastrarDados(T).