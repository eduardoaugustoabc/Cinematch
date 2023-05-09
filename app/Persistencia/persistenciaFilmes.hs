module Persistencia.PersistenciaFilmes where

import Filme

import qualified Data.ByteString.Lazy as BL
import qualified Data.Csv as Csv
import qualified Data.Vector as V

parseFilmes :: [Filme] -> [[String]]
parseFilmes [] = []
parseFilmes (x:xs) = getAtributos x : parseFilmes xs

salvaFilmesPersistentemente :: [Filme] -> IO ()
salvaFilmesPersistentemente filmes = do
  let listaDeFilmes = parseFilmes filmes
  let novoCSV = Csv.encode listaDeFilmes
  BL.writeFile "IMDB-Movie-Data.csv" novoCSV
  putStrLn ""
