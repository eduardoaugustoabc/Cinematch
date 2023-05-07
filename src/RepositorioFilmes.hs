module RepositorioFilmes where

import Filme
import Util.Split


{-Tipo Repositorio de Filmes. Guarda um array de filmes.-}

data RepositorioFilmes = RepositorioFilmes {
  filmes :: [Filme]
} deriving (Show)

{-Chama o construtor de Filme e insere os dados-}
criarFilme :: String -> [String] -> String -> String-> [String] -> String -> String -> Int -> Float -> Filme
criarFilme titulo generos descricao diretor atores dataLancamento duracao notaImdb notaUsuario =
  Filme { titulo = titulo, generos = generos, descricao = descricao, diretor = diretor, atores = atores, dataLancamento = dataLancamento, duracao = duracao, notaImdb = notaImdb, notaUsuario = notaUsuario }

{-Get do repositório, retorna a lista de filmes-}
getRepFilmes :: RepositorioFilmes -> [Filme]
getRepFilmes (RepositorioFilmes fs) = fs

{-Adiciona filme no repositório. Recebe um repositório e o filme a ser adicionado, concatena o array de filmes com o novo filme dentro do repositório e retorna o resltado que é um RepositorioFilmes-}
addFilmeRepositorio :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmeRepositorio repositorio novoFilme = RepositorioFilmes {filmes = filmes repositorio ++ [novoFilme]}

{-Exibe todos os filmes do repositório-}
exibirRep :: RepositorioFilmes -> IO ()
exibirRep rep = print rep

{-Adiciona um filme no repositório. Usa a função lerCriaFilme para ler os dados do filme e , assim , adicioná-los ao repositório-}
addFilme :: RepositorioFilmes -> IO RepositorioFilmes
addFilme rep = do
  oFilme <- lerCriaFilme
  return (addFilmeRepositorio rep oFilme)

{-Função usada para ler os dados do filme , criar e retornar um filme com os atributos lidos-}
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
  putStrLn "Digite o ano de lançamento do filme:"
  dataLancamento <- getLine
  putStrLn "Digite a duração do filme (em minutos):"
  duracao <- getLine
  putStrLn "Digite a nota do filme no IMDb (entre 0 e 100):"
  notaImdb <- getLine
  putStrLn "Digite a nota do filme na sua opiniao (entre 0.0 e 10.0):"
  notaUsuario <- getLine
  let filme = criarFilme titulo (split ',' generos) descricao diretor (split ',' atores) dataLancamento duracao (read notaImdb :: Int) (read notaUsuario :: Float)
  return filme

{-
add :: String -> String -> String -> String -> String -> String -> String -> String -> String -> IO ()
add titulo generos descricao diretor atores dataLancamento duracao notaImdb notaUsuario = do
  conteudo <- BL.readFile "IMDB-Movie-Data.csv"
  case Csv.decode Csv.NoHeader conteudo of
    Left erro -> print erro
    Right linhas -> do
      let novaLinha = ["titulo", "diretor", "ano"]
          novoCSV = V.toList linhas ++ [novaLinha]
      BL.writeFile "IMDB-Movie-Data.csv" (Csv.encode novoCSV)
      putStrLn "Linha adicionada com sucesso!"-}