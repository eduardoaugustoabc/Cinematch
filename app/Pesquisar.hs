module Pesquisar where

import Filme
import RepositorioFilmes

pesquisaPorNome :: [Filme] -> String -> Maybe Filme
pesquisaPorNome filmes nomeFilme =
  case filter (ehIgual nomeFilme) filmes of
    []    -> Nothing
    (x:_) -> Just x
  where
    ehIgual nome filme = nome == (getTituloFilme filme)

pesquisaPorGenero :: [Filme] -> String -> Maybe [Filme]
pesquisaPorGenero filmes genero =
  case filter (ehDoGenero genero) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    ehDoGenero genero filme = containsString genero (getGenerosFilme filme)

pesquisaPorAno :: [Filme] -> String -> Maybe [Filme]
pesquisaPorAno filmes ano = 
  case filter (mesmoAno ano) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoAno ano filme = ano == (getDataFilme filme)

pesquisaPorDiretor :: [Filme] -> String -> Maybe [Filme]
pesquisaPorDiretor filmes diretor = 
  case filter (mesmoDiretor diretor) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoDiretor diretor filme = diretor == (getDiretorFilme filme)

pesquisaPorAtor :: [Filme] -> String -> Maybe [Filme]
pesquisaPorAtor filmes ator =
  case filter (mesmoAtor ator) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoAtor ator filme = containsString ator (getAtoresFilme filme)

containsString :: String -> [String] -> Bool
containsString str list = elem str list

selecaoPesquisa::RepositorioFilmes -> IO()
selecaoPesquisa rep = do
  putStrLn "Digite o número de acordo com a pesquisa que deseja fazer:\n1)Nome 2)Gênero 3)Ano 4)Diretor 5) Ator"
  cmd <- getLine
  let filmes = getRepFilmes rep
  case cmd of
    "1" -> do
      putStrLn "Digite o nome do filme:"
      nome <- getLine
      let resultado = pesquisaPorNome filmes nome
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filme -> print filme
    "2" -> do
      putStrLn "Digite o gênero:"
      genero <- getLine
      let resultado = pesquisaPorGenero filmes genero
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filmes -> mapM_ print filmes
    "3" -> do
      putStrLn "Digite o ano:"
      ano <- getLine
      let resultado = pesquisaPorAno filmes ano
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filmes -> mapM_ print filmes
    "4" -> do
      putStrLn "Digite o Diretor:"
      diretor <- getLine
      let resultado = pesquisaPorDiretor filmes diretor
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filmes -> mapM_ print filmes
    "5" -> do
      putStrLn "Digite o Ator:"
      ator <- getLine
      let resultado = pesquisaPorAtor filmes ator
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filmes -> mapM_ print filmes
    _ -> putStrLn "Opção inválida."  