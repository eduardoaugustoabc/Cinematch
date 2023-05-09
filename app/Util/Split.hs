module Util.Split where

{-Função que transforma uma String em um array de Strings. Função usada principalmente na criação de filmes , generos e atores.-}
split :: Char -> String -> [String]
split separador str = separateBy separador str "" []

{-Função auxiliar usada pela função split. separa a string por um determinado caractere.-}
separateBy :: Char -> String -> String -> [String] -> [String]
separateBy _ [] strAux lista = lista ++ [strAux]
separateBy separador (x : xs) strAux lista
  | x /= separador = separateBy separador xs (strAux ++ [x]) lista
  | otherwise = separateBy separador xs "" (lista ++ [strAux])