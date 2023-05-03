module RepositorioFilmes where

import Filme

data RepositorioFilmes = RepositorioFilmes {
    filmes :: [Filme]
} deriving (Show)

criarFilme :: String -> [String] -> String -> String-> [String] -> String -> String -> Float -> String -> String -> Int -> Filme
criarFilme titulo generos descricao diretor atores dataLancamento duracao notaUsuarios usuariosVotates arrecadacao notaImdb =
  Filme { titulo = titulo, generos = generos, descricao = descricao, diretor = diretor, atores = atores, dataLancamento = dataLancamento, duracao = duracao, notaUsuarios = notaUsuarios, usuariosVotates = usuariosVotates, arrecadacao = arrecadacao, notaImdb = notaImdb, notaUsuario = 0.0 }

getFilmes :: RepositorioFilmes -> [Filme]
getFilmes (RepositorioFilmes { filmes = fs }) = fs

getFilme :: String -> RepositorioFilmes -> String
getFilme nomeFilme repoFilmes =
  let
    filmeEncontrado = head $ filter (\f -> titulo f == nomeFilme) (filmes repoFilmes)
  in
    show filmeEncontrado

addFilmeRepositorio :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmeRepositorio repositorio novoFilme = RepositorioFilmes {filmes = filmes repositorio ++ [novoFilme]}

addFilmee :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmee repositorio novoFilme = repositorio { filmes = (filmes repositorio ++ [novoFilme]) }
