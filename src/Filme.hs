module Filme where

{-Tipo Filme. tem todos os itens necessarios de um filme.-}

data Filme = Filme {
  titulo :: String,
  generos :: [String],
  descricao :: String,
  diretor :: String,
  atores :: [String],
  dataLancamento :: String,
  duracao :: String,
  notaUsuarios :: Float,
  usuariosVotates :: String,
  arrecadacao :: String,
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
           "\nNota Usuários: " ++ show (notaUsuarios f) ++
           "\nUsuários que votaram: " ++ usuariosVotates f ++
           "\nArrecadação: U$ " ++ arrecadacao f ++ " milhões" ++
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

getNotaUsuariosFilme :: Filme -> Float
getNotaUsuariosFilme (Filme { notaUsuarios = nU }) = nU
