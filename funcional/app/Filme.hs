module Filme where

import Data.List (intercalate)


{-Tipo Filme. Possui todos os itens necessarios para um filme.
Podem existir filmes de mesmo nome, mas não comaa mesma data.-}
data Filme = Filme {
  titulo :: String,
  generos :: [String],
  descricao :: String,
  diretor :: String,
  atores :: [String],
  dataLancamento :: String,
  duracao :: String,
  notaImdb :: Int,
  notaUsuario :: Float
  }

{-Representação textual do Filme.-}
instance Show Filme where
  show f = "\n-----------------------------" ++
           "\nTítulo: " ++ titulo f ++
           "\nGêneros: " ++ show (generos f) ++
           "\nDescrição: " ++ descricao f ++
           "\nDiretor: " ++ diretor f ++
           "\nAtores: " ++ show (atores f) ++
           "\nData de lançamento: " ++ dataLancamento f ++
           "\nDuração: " ++ duracao f ++ " minutos" ++
           "\nNota do IMDB: " ++ show (notaImdb f) ++
           "\nNota do usuário: " ++ show (notaUsuario f) ++
           "\n-----------------------------"

{-Gets de dados de um filme-}
getGenerosFilme :: Filme -> [String]
getGenerosFilme (Filme { generos = gn}) = gn

getDiretorFilme :: Filme -> String
getDiretorFilme (Filme { diretor = dr}) = dr

getAtoresFilme :: Filme -> [String]
getAtoresFilme (Filme { atores = at}) = at

getTituloFilme :: Filme -> String
getTituloFilme (Filme { titulo = t}) = t

getDataFilme :: Filme -> String
getDataFilme (Filme { dataLancamento = d}) = d

getNotaImdbFilme :: Filme -> Int
getNotaImdbFilme (Filme { notaImdb = nI }) = nI

getNotaUsuario :: Filme -> Float
getNotaUsuario (Filme { notaUsuario = nU }) = nU

getAtributos :: Filme -> [String]
getAtributos (Filme { titulo = t, generos = g, descricao = d, diretor = dr, atores = at, dataLancamento = dt, duracao = du, notaImdb = nI, notaUsuario = nU }) =
  [t] ++ [intercalate "," g] ++ [d] ++ [dr] ++ [intercalate "," at] ++ [dt] ++ [du] ++ [show nI] ++ [show nU]