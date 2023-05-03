module Filme where

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
