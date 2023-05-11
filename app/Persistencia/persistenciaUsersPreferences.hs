module Persistencia.PersistenciaUsersPreferences where

import Filme

import qualified Data.ByteString.Lazy as BL
import qualified Data.Csv as Csv
import qualified Data.Vector as V

salvaPreferenciasUsuarioPersistentemente :: [String] -> [String] -> [String] -> [Filme] -> [Filme] -> [Filme] -> IO ()
salvaPreferenciasUsuarioPersistentemente generos diretores atores favoritos watch assistidos = do
  saveFavoritos <- return $ parseFilmeTOString favoritos []
  saveWatch <- return $ parseFilmeTOString watch []
  saveAssistidos <- return $ parseFilmeTOString assistidos []
  let listaDeFilmes = concat [[generos], [diretores], [atores], [saveFavoritos], [saveWatch], [saveAssistidos]]
  let novoCSV = Csv.encode listaDeFilmes
  BL.writeFile "UserPreferences.csv" novoCSV
  putStrLn ""



parseFilmeTOString :: [Filme] -> [String] -> [String]
parseFilmeTOString [] saidaArray = saidaArray ++ ["_"]
parseFilmeTOString (x:xs) saidaArray = parseFilmeTOString xs (concat [[(converte x)], saidaArray])

converte :: Filme -> String
converte filme =  (getTituloFilme filme) ++ "_" ++ (getDataFilme filme)