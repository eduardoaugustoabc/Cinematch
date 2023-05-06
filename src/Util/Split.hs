module Util.Split where

split :: Char -> String -> [String]
split separador str = separateBy separador str "" []

separateBy :: Char -> String -> String -> [String] -> [String]
separateBy _ [] strAux lista = lista ++ [strAux]
separateBy separador (x : xs) strAux lista
  | x /= separador = separateBy separador xs (strAux ++ [x]) lista
  | otherwise = separateBy separador xs "" (lista ++ [strAux])