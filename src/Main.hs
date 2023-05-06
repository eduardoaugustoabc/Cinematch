import Filme
import RepositorioFilmes
import Usuario
import Util.Split

import Text.CSV



main :: IO ()
main = do
  putStrLn "---------------------------------------------------------------"
  putStrLn "                 Bem vindo(a) ao CINEMATCH                     "
  putStrLn "---------------------------------------------------------------"
  let arquivo = "IMDB-Movie-Data.csv"
  resultado <- parseCSVFromFile arquivo
  case resultado of
    Right linhas -> do
      addAll linhas (RepositorioFilmes { filmes = [] }) (Usuario { generosFav = ["Mystery", "sci-fi", "Action", "Adventure", "Biography"]
                       , diretoresFav = ["Tarantino", "Ridley Scott"]
                       , atoresFav = ["Keanu", "Scarlett Johansson", "waltz", "Charlize Theron", "Charlie Hunnam", "Robert Pattinson", "Sienna Miller", "Tom Holland"]
                       , filmesFav = []
                       , watchlist = []
                       , filmesAssistidos = []
                       })           
  
                       

opcoes :: RepositorioFilmes -> Usuario -> IO ()
opcoes rep user = do
  putStrLn "++---------------------Escolha uma ação----------------------++"
  putStrLn " 1) Exibir Filme"
  putStrLn " 2) Favoritar Gênero"
  putStrLn " 3) Favoritar Ator"
  putStrLn " 4) Favoritar Diretor"
  putStrLn " 5) Recomendação"
  putStrLn " 6) Lista de diretores favoritos"
  putStrLn " 7) Lista de filmes que se deseja assistir"
  putStrLn " 8) Cadastrar Filme"
  putStrLn " 9) Dashboard"
  putStrLn " 10) EXIT PROGRAM"
  putStr "Opção escolhida : "
  opcao <- getLine
  putStrLn "++-----------------------------------------------------------++"
  if opcao == "10"
    then return ()
  else do
    novoRepo <- acoes opcao rep user
    return ()

acoes :: String -> RepositorioFilmes -> Usuario -> IO ()
acoes cmd rep user
  | cmd == "1"     =  do
    exibirRep rep
    opcoes rep user
  | cmd == "2"     = do
    putStr "Qual gênero deseja favoritar : "
    com <- getLine
    us <- (favoritarGenenero user com)
    print (getGeneros us)
    opcoes rep us
  | cmd == "3"     = do
    putStr "Qual ator deseja favoritar : "
    com <- getLine
    us <- (favoritarAtor user com)
    print (getAtores us)
    opcoes rep us
  | cmd == "4"     = do
    putStr "Qual diretor deseja favoritar : "
    com <- getLine
    us <- (favoritarDiretor user com)
    print (getDiretores us)
    opcoes rep us
  | cmd == "5"     = do
    qtd <- readLn :: IO Int
    print(recomenda qtd (getRepFilmes rep) user)
    opcoes rep user
  | cmd == "6"     = do
    print(getDiretores user)
    opcoes rep user
  | cmd == "7"     = do
    print(getWatch user)
    opcoes rep user
  | cmd == "8"     = do
    repo <- addFilme rep
    opcoes repo user
  | cmd == "10"    = do
    return ()
  | otherwise      = do
    putStrLn "Comando inválido ou não implementado até o momento"
    opcoes rep user










exibirRep :: RepositorioFilmes -> IO ()
exibirRep rep = print rep

addFilme :: RepositorioFilmes -> IO RepositorioFilmes
addFilme rep = do
  oFilme <- lerCriaFilme
  return (addFilmeRepositorio rep oFilme)

lerCriaFilme :: IO Filme
lerCriaFilme = do
  putStrLn "Digite o nome do filme:"
  titulo <- getLine
  putStrLn "Digite os gêneros do filme (separados por espaço):"
  generos <- getLine
  putStrLn "Digite a descrição do filme:"
  descricao <- getLine
  putStrLn "Digite o nome do diretor do filme:"
  diretor <- getLine
  putStrLn "Digite os nomes dos atores do filme (separados por espaço):"
  atores <- getLine
  putStrLn "Digite a data de lançamento do filme (formato: dd/mm/aaaa):"
  dataLancamento <- getLine
  putStrLn "Digite a duração do filme (em minutos):"
  duracao <- getLine
  putStrLn "Digite a nota do filme no IMDb (entre 0 e 100):"
  notaImdb <- getLine
  putStrLn "Digite a nota do filme na sua opiniao (entre 0.0 e 10.0):"
  notaUsuario <- getLine
  let filme = criarFilme titulo (split ',' generos) descricao diretor (split ',' atores) dataLancamento duracao (read notaImdb :: Int) (read notaUsuario :: Float)
  return filme


addAll :: [[String]] -> RepositorioFilmes -> Usuario -> IO ()
addAll [x] rep user = opcoes rep user
addAll (x:xs) rep user = do
  let titulo = x !! 1 
      generos = x !! 2
      descricao = x !! 3 
      diretor = x !! 4
      atores = x !! 5
      dataLancamento = x !! 6
      duracao = x !! 7
      notaImdb = x !! 11
      filme = criarFilme titulo (split ',' generos) descricao diretor (split ',' atores) dataLancamento duracao (read notaImdb :: Int) 0.0
  addAll xs (addFilmeRepositorio rep filme) user
