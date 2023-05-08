module Dashboard where

import Usuario
import Filme
import qualified Data.Map.Strict as Map
import Data.List (intercalate)

quantidadeFilmesAssistidos :: Usuario -> Int
quantidadeFilmesAssistidos usuario = length (getFilmesAssistidos usuario)

mediadeNotasUsuario :: Usuario -> Float
mediadeNotasUsuario usuario = somaNotas filmesAssistidos / fromIntegral (length filmesAssistidos)
  where
    filmesAssistidos = getFilmesAssistidos usuario
    somaNotas [] = 0
    somaNotas (h:t) = getNotaUsuario h + somaNotas t

generosMaisAssistidos :: Usuario -> [String]
generosMaisAssistidos usuario = take 3 $ map show $ reverse $ Map.toList $ Map.fromListWith (+) generosAssistidos
  where
    filmesAssistidos = getFilmesAssistidos usuario
    generosAssistidos = [(genero, 1) | filme <-filmesAssistidos, genero <- getGenerosFilme filme]

mediaNotasGeneros :: Usuario -> Map.Map String Float
mediaNotasGeneros usuario = Map.fromListWith mediaPorGenero notasPorGenero
  where
    filmesAssistidos = getFilmesAssistidos usuario
    generosFilmesAssistidos = concatMap getGenerosFilme filmesAssistidos
    notasFilmesAssistidos = map getNotaUsuario filmesAssistidos
    notasPorGenero = zip generosFilmesAssistidos notasFilmesAssistidos
    mediaPorGenero soma notas = (soma + notas) / 2


dashboardString :: Usuario -> String
dashboardString usuario = "Filmes assistidos: " ++ show (quantidadeFilmesAssistidos usuario) ++ "\n" ++
                   "Média das notas: " ++ show (mediadeNotasUsuario usuario) ++ "\n" ++
                   "Gêneros mais assistidos: " ++ generos ++ "\n" ++
                   "Média das notas por gênero:\n" ++ notasPorGenero
  where
    generos = intercalate ", " (generosMaisAssistidos usuario)
    notasPorGenero =
      intercalate "\n" $
      map (\(genero, nota) -> genero ++ ": " ++ show nota) $
      Map.toList $ mediaNotasGeneros usuario