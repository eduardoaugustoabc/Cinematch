import Filme
import RepositorioFilmes
import Usuario

main :: IO ()
main = do
  print "\nAções:\n[A]: Cadastrar Filme\n[B]: Exibir Filme\n[S]: Sair\n[F]: favoritar ator\n[O]: favoritar diretor\n[I]: favoritar genero\n [W]: Recomendacao"
  comando <- readLn :: IO Char
  repositorio <- acoes (RepositorioFilmes { filmes = [] }) (Usuario { generosFav = ["ação", "aventura"]
                       , diretoresFav = ["Tarantino"]
                       , atoresFav = ["Keanu Reeves", "Scarlett Johansson"]
                       , filmesFav = []
                       , watchlist = []
                       , filmesAssistidos = []
                       }) comando
  print "\nFim"

acoes :: RepositorioFilmes -> Usuario -> Char -> IO RepositorioFilmes
acoes rep us cmd
    | cmd == 'A' = do
        repo <- addFilme rep
        comando <- readLn :: IO Char
        acoes repo us comando
    | cmd == 'B' = do
        exibirFilme rep
        comando <- readLn :: IO Char
        acoes rep us comando
    | cmd == 'F' = do
        com <- readLn :: IO String
        us <- (favoritarAtor us com)
        print (getAtores us)
        comando <- readLn :: IO Char
        acoes rep us comando
    | cmd == 'I' = do
        com <- readLn :: IO String
        us <- (favoritarGenenero us com)
        print (getGeneros us)
        comando <- readLn :: IO Char
        acoes rep us comando
    |cmd == 'O' = do
        com <- readLn :: IO String
        us <- (favoritarDiretor us com)
        print (getDiretores us)
        comando <- readLn :: IO Char
        acoes rep us comando
    | cmd == 'W' = do
      qtd <- readLn :: IO Int
      print(recomenda qtd (getFilmesFav us) (getRepFilmes rep) us)
      comando <- readLn :: IO Char
      acoes rep us comando
    | cmd == 'S' = return rep
    | otherwise = do
        putStrLn "Comando inválido"
        comando <- readLn :: IO Char
        acoes rep us comando

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
  notaImdb <- readLn :: IO Int
  let filme = criarFilme titulo generos descricao diretor atores dataLancamento duracao notaImdb
  return filme
