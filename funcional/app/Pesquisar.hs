module Pesquisar where

import Filme
import RepositorioFilmes

{-Método usado para pesquisar determinado filme pelo seu nome-}
pesquisaPorNome :: [Filme] -> String -> Maybe [Filme]
pesquisaPorNome filmes nome = 
  case filter (mesmoAno nome) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoAno nome filme = nome == (getTituloFilme filme)

{-Método usado para pesquisar determinado filme pelo seu gênero-}
pesquisaPorGenero :: [Filme] -> String -> Maybe [Filme]
pesquisaPorGenero filmes genero =
  case filter (ehDoGenero genero) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    ehDoGenero genero filme = containsString genero (getGenerosFilme filme)

{-Método usado para pesquisar determinado filme pelo seu ano de lançamento-}
pesquisaPorAno :: [Filme] -> String -> Maybe [Filme]
pesquisaPorAno filmes ano = 
  case filter (mesmoAno ano) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoAno ano filme = ano == (getDataFilme filme)

{-Método usado para pesquisar determinado filme pelo seu diretor-}
pesquisaPorDiretor :: [Filme] -> String -> Maybe [Filme]
pesquisaPorDiretor filmes diretor = 
  case filter (mesmoDiretor diretor) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoDiretor diretor filme = diretor == (getDiretorFilme filme)

{-Método usado para pesquisar determinado filme por um de seus atores-}
pesquisaPorAtor :: [Filme] -> String -> Maybe [Filme]
pesquisaPorAtor filmes ator =
  case filter (mesmoAtor ator) filmes of
    []    -> Nothing
    lista -> Just lista
  where
    mesmoAtor ator filme = containsString ator (getAtoresFilme filme)

{-Método usado para analisar se determinada lista de strings possui uma string específica-}
containsString :: String -> [String] -> Bool
containsString str list = elem str list

{-Método usado para adequar a pesquisa de acordo com o quê o usuário quer; funciona como
algumas funcionalidades do main e trata exceções, como opções inválidas-}
selecaoPesquisa::RepositorioFilmes -> IO()
selecaoPesquisa rep = do
  putStrLn "Digite o número de acordo com a pesquisa que deseja fazer: "
  putStrLn "1) Nome "
  putStrLn "2) Gênero "
  putStrLn "3) Ano "
  putStrLn "4) Diretor "
  putStrLn "5) Ator"
  putStrLn  "Qual sua escolha : "
  cmd <- getLine
  let filmes = getRepFilmes rep
  case cmd of
    "1" -> do
      putStrLn "Digite o nome do filme:"
      nome <- getLine
      let resultado = pesquisaPorNome filmes nome
      case resultado of
        Nothing -> putStrLn "Nenhum filme encontrado."
        Just filmes -> mapM_ print filmes
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