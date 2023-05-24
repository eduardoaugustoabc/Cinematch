module Persistencia.PersistenciaFilmes where

import Filme

import qualified Data.ByteString.Lazy as BL
import qualified Data.Csv as Csv
import qualified Data.Vector as V

{-
  Dado todos os filmes do repositório do usuário , faz uma varedura e retorna uma matriz de filmes , na qual cada elemento será armazenada como uma linha no arquivo IMDB-Movie-Data.csv
  Cada linha será do tipo:
    nome: String, generos: [String], descrição: String, diretor: String, atores: [String], ano: Int, duração: Int, notaIMDB: Int, notaUsuario: Float
-}
parseFilmes :: [Filme] -> [[String]]
parseFilmes [] = []
parseFilmes (x:xs) = getAtributos x : parseFilmes xs


{-
  Usa a função parseFilmes para criar uma matriz de filmes e salva esses filmes (persistentemente) no arquivo IMDB-Movie-Data.csv , quando a aplicação for encerrada.
-}
salvaFilmesPersistentemente :: [Filme] -> IO ()
salvaFilmesPersistentemente filmes = do
  let listaDeFilmes = parseFilmes filmes
  let novoCSV = Csv.encode listaDeFilmes
  BL.writeFile "IMDB-Movie-Data.csv" novoCSV
  putStrLn ""
