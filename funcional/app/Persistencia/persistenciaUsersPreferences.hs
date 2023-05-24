module Persistencia.PersistenciaUsersPreferences where

import Filme

import qualified Data.ByteString.Lazy as BL
import qualified Data.Csv as Csv
import qualified Data.Vector as V

{-
  Dadas as preferencias do usuário , instancia as funções necessárias para manipulá-las e salvá-las da forma correta no arquivo UserPreferences.csv.
-}
salvaPreferenciasUsuarioPersistentemente :: [String] -> [String] -> [String] -> [Filme] -> [Filme] -> [Filme] -> IO ()
salvaPreferenciasUsuarioPersistentemente generos diretores atores favoritos watch assistidos = do
  saveFavoritos <- return $ parseFilmeTOString favoritos []
  saveWatch <- return $ parseFilmeTOString watch []
  saveAssistidos <- return $ parseFilmeTOString assistidos []
  let listaDeFilmes = concat [[generos ++ ["_"]], [diretores ++ ["_"]], [atores ++ ["_"]], [saveFavoritos], [saveWatch], [saveAssistidos]]
  let novoCSV = Csv.encode listaDeFilmes
  BL.writeFile "UserPreferences.csv" novoCSV
  putStrLn ""


{-Dado um array de filmes, o converte para uma representacao do tipo ["nomeFilme_dataLancamentoFilme"] , para que possamos salvar um arrsy com os "Apontadores" para uma sequência de filme que estão em alguma preferência do usuário (Favoritos , Lista de desejos ou Assistidos).-}
parseFilmeTOString :: [Filme] -> [String] -> [String]
parseFilmeTOString [] saidaArray = saidaArray ++ ["_"]
parseFilmeTOString (x:xs) saidaArray = parseFilmeTOString xs (concat [[(converte x)], saidaArray])

{-Dado um filme, o converte para uma representacao do tipo "nomeFilme_dataLancamentoFilme" , para que possamos salvar uma espécie de "Apontador" para um filme do repositório.-}
converte :: Filme -> String
converte filme =  (getTituloFilme filme) ++ "_" ++ (getDataFilme filme)