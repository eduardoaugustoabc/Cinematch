import Filme
import RepositorioFilmes

main :: IO ()
main = do
  print "\nAções:\n[A]: Cadastrar Filme\n[B]: Exibir Filme\n[S]: Sair"
  comando <- readLn :: IO Char
  repositorio <- acoes (RepositorioFilmes { filmes = [] }) comando
  --repositorio <- addFilme repositorio
  --repositorio <- addFilme repositorio
  print repositorio

acoes :: RepositorioFilmes -> Char -> IO RepositorioFilmes
acoes rep cmd
    | cmd == 'A' = do
        repo <- addFilme rep
        comando <- readLn :: IO Char
        acoes repo comando
    | cmd == 'B' = do
        exibirFilme rep
        comando <- readLn :: IO Char
        acoes rep comando
    | cmd == 'S' = return rep
    | otherwise = do
        putStrLn "Comando inválido"
        comando <- readLn :: IO Char
        acoes rep comando

exibirFilme :: RepositorioFilmes -> IO ()
exibirFilme rep = print rep

addFilme :: RepositorioFilmes -> IO RepositorioFilmes
addFilme rep = do
  oFilme <- lerCriaFilme
  return (addFilmeRepositorio rep oFilme)

lerCriaFilme :: IO Filme
lerCriaFilme = do
  titulo <- readLn :: IO String
  generos <- readLn :: IO [String]
  descricao <- readLn :: IO String
  diretor <- readLn :: IO String
  atores <- readLn :: IO [String]
  dataLancamento <- readLn :: IO String
  duracao <- readLn :: IO String
  notaUsuarios <- readLn :: IO Float
  qtdUsuarios <- readLn :: IO String
  arrecadacao <- readLn :: IO String
  notaImdb <- readLn :: IO Int
  let filme = criarFilme titulo generos descricao diretor atores dataLancamento duracao notaUsuarios qtdUsuarios arrecadacao notaImdb
  return filme
