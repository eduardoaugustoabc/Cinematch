import Filme
import RepositorioFilmes
import Usuario
import Util.Split

import Text.CSV


{-Função de inicialização do projeto. Lê o arquivo IMDB-Movie-Data.csv e , com o resultado da leitura, instancia a função addAll , para que a aplicação siga seu fluxo. -}
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
  
                       
{-Função responsavel por exibir e receber (input) a opção do usuário sobre o que ele deseja usar da aplicação. Instância acoes com o valor recebido.-}
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

{-Função que , de acordo com o valor recebido da função opções , irá realizar operações (instanciando as funções necessárias).-}
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

{-No início da aplicação , adiciona todos os filmes do arquivo IMDB-Movie-Data.csv no repositório de filmes. Após isso , instância a função opcoes.-}
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