module Persistencia.PersistenciaUsersPreferences where

import Filme

import qualified Data.ByteString.Lazy as BL
import qualified Data.Csv as Csv
import qualified Data.Vector as V

salvaPreferenciasUsuarioPersistentemente :: [String] -> [String] -> [String] -> [Filme] -> [Filme] -> [Filme] -> IO ()
salvaPreferenciasUsuarioPersistentemente generos diretores atores favoritos watch assistidos = do
  let listaDeFilmes = [generos] ++ [diretores] ++ [atores] ++ [["1","2"]] ++ [["1","2","3"]] ++ [["1","2","4"]]
  let novoCSV = Csv.encode listaDeFilmes
  BL.writeFile "UserPreferences.csv" novoCSV
  putStrLn ""
