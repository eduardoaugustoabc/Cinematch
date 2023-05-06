module RepositorioFilmes where

import Filme

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
