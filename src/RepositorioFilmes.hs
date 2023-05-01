module RepositorioFilmes where

import Filme

data RepositorioFilmes = RepositorioFilmes {
    filmes :: [Filme]
} deriving (Show)

addFilme :: String -> [String] -> String -> String-> [String] -> String -> String -> Float -> String -> String -> Int -> Filme
addFilme titulo generos descricao diretor atores dataLancamento duracao notaUsuarios usuariosVotates arrecadacao notaIMDB =
  Filme { titulo = titulo, generos = generos, descricao = descricao, diretor = diretor, atores = atores, dataLancamento = dataLancamento, duracao = duracao, notaUsuarios = notaUsuarios, usuariosVotates = usuariosVotates, arrecadacao = arrecadacao, notaImdb = notaIMDB, notaUsuario = 0.0}

getFilme :: String -> RepositorioFilmes -> String
getFilme nomeFilme repoFilmes =
  let
    filmeEncontrado = head $ filter (\f -> titulo f == nomeFilme) (filmes repoFilmes)
  in
    show filmeEncontrado

-- Função para adicionar um filme ao repositório
addFilmeRepositorio :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmeRepositorio repFilmes filme = RepositorioFilmes { filmes = filme : filmes repFilmes }
