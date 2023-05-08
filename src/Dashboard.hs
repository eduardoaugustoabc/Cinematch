module Dashboard where

import Usuario
import Filme

calculaQuantidadeFilmesAssistidos :: Usuario -> Int
calculaQuantidadeFilmesAssistidos usuario = length (getFilmesAssistidos usuario)

calculaMediadeNotasUsuario :: Usuario -> Float
calculaMediadeNotasUsuario usuario = somaNotas filmesAssistidos / fromIntegral (length filmesAssistidos)
  where
    filmesAssistidos = getFilmesAssistidos usuario
    somaNotas [] = 0
    somaNotas (h:t) = getNotaUsuario h + somaNotas t

dashboardString :: Usuario -> String
dashboardString usuario = "Filmes assistidos: " ++ show (calculaQuantidadeFilmesAssistidos usuario) ++ "\n" ++
                   "Média das notas: " ++ show (calculaMediadeNotasUsuario usuario)