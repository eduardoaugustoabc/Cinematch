module Usuario where

import Filme
import RepositorioFilmes
import Util.Split
{-# LANGUAGE BangPatterns #-}

{-Tipo usuário, guarda as informações de gostos do usuário-}

data Usuario = Usuario {
    generosFav :: [String],
    diretoresFav :: [String],
    atoresFav :: [String],
    filmesFav :: [Filme],
    watchlist :: [Filme],
    filmesAssistidos :: [Filme]
}

{-Gets dos dados do usuário-}

getWatch :: Usuario -> [Filme]
getWatch (Usuario { watchlist = w}) = w

getGeneros :: Usuario -> [String]
getGeneros (Usuario { generosFav = gn}) = gn

getDiretores :: Usuario -> [String]
getDiretores (Usuario { diretoresFav = dr}) = dr

getAtores :: Usuario -> [String]
getAtores (Usuario { atoresFav = at}) = at

getFilmesFav :: Usuario -> [Filme]
getFilmesFav (Usuario { filmesFav = fs}) = fs

getFilmesAssistidos :: Usuario -> [Filme]
getFilmesAssistidos (Usuario { filmesAssistidos = fa } ) = fa

{-Adicionam itens nas listas de favoritos e watchlist-}

addWatch:: Usuario -> Filme -> IO Usuario
addWatch us filme = do
  if (verificaSeEsta filme (getWatch us)) then do
    putStrLn "O filme já está na lista de desejos!"
    return us
  else do
    let watchAtualizado = (filme : getWatch us)
    return us { watchlist = watchAtualizado }
  
removeWatch :: Usuario -> Filme -> IO Usuario
removeWatch us filme = do
  if (verificaSeEsta filme (getWatch us)) then do
    let watchList = percorreFilme filme (getWatch us)
    return us { watchlist = watchList }
  else do
    putStrLn "O filme não estava na lista de desejos!"
    return us

addAssistidos :: Usuario -> Filme -> IO Usuario
addAssistidos us filme = do
  if (verificaSeEsta filme (getFilmesAssistidos us)) then do
    putStrLn "O filme já está na lista de assistidos!"
    return us
  else do
    let filmesAssistidos1 = (filme : getFilmesAssistidos us)
    return us { filmesAssistidos = filmesAssistidos1 }

removeAssistidos :: Usuario -> Filme -> IO Usuario
removeAssistidos us filme = do
  if (verificaSeEsta filme (getFilmesAssistidos us)) then do
    let assistidos = percorreFilme filme (getFilmesAssistidos us)
    return us { filmesAssistidos = assistidos }
  else do
    putStrLn "O filme não estava na lista de assistidos!"
    return us

favoritarAtor :: Usuario -> String -> IO Usuario
favoritarAtor us ator = do
  if (verificaSeEstaString ator (getAtores us)) then do
    putStrLn "O ator já está na lista de favoritos"
    return us
  else do
    let atoresFavoritosAtualizados = (ator : getAtores us)
    return us { atoresFav = atoresFavoritosAtualizados }

favoritarGenero :: Usuario -> String -> IO Usuario
favoritarGenero us genero = do
  let generos = ["Action","Adventure","Horror","Animation","Fantasy","Comedy","Biography","Drama","Family","History","Sci-Fi","Thriller","Mystery","Crime","Western","Romance","War","Musical","Music","Sport"];
  if (verificaSeEstaString genero generos) then do
    if (verificaSeEstaString genero (getGeneros us)) then do
      putStrLn "O gênero já está na lista de favoritos"
      return us
    else do
      let generosFavoritosAtualizados = (genero : getGeneros us)
      return us { generosFav = generosFavoritosAtualizados }
  else do
    putStrLn "O gênero é inválido!"
    return us


favoritarDiretor :: Usuario -> String -> IO Usuario
favoritarDiretor us diretor = do
  if (verificaSeEstaString diretor (getDiretores us)) then do
    putStrLn "O diretor já está na lista de favoritos!"
    return us
  else do
    let diretoresFavoritosAtualizados = (diretor : getDiretores us)
    return us { diretoresFav = diretoresFavoritosAtualizados }

favoritarFilme :: Usuario -> Filme -> IO Usuario
favoritarFilme us filme = do
  if (verificaSeEsta filme (getFilmesFav us)) then do
    putStrLn "Filme já está nos favoritos!"
    return us
  else do
    let filmesFavoritosAtualizados = (filme : getFilmesFav us)
    return us { filmesFav = filmesFavoritosAtualizados }

desfavoritarFilme :: Usuario -> Filme -> IO Usuario
desfavoritarFilme us filme = do
  if (verificaSeEsta filme (getFilmesFav us)) then do
    let filmesFavoritosAtualizados = percorreFilme filme (getFilmesFav us)
    return us { filmesFav = filmesFavoritosAtualizados }
  else do
    putStrLn "O filme não estava na lista de favoritos!"
    return us

desfavoritarAtor :: Usuario -> String -> IO Usuario
desfavoritarAtor us nome = do
  let atoresFavoritosAtualizados = percorreString nome (getAtores us) 
  return us { atoresFav = atoresFavoritosAtualizados }
  
desfavoritarGenero :: Usuario -> String -> IO Usuario
desfavoritarGenero us genero = do
  let generosFavoritosAtualizados = percorreString genero (getGeneros us)
  return us { generosFav = generosFavoritosAtualizados }
  
desfavoritarDiretor :: Usuario -> String -> IO Usuario
desfavoritarDiretor us diretor = do
  let diretoresFavoritosAtualizados = percorreString diretor (getDiretores us)
  return us { diretoresFav = diretoresFavoritosAtualizados }

percorreString :: String -> [String] -> [String]
percorreString nome [] = []
percorreString nome (h:t) 
  | h == nome   = percorreString nome t
  | otherwise   = [h] ++ percorreString nome t

percorreFilme :: Filme -> [Filme] -> [Filme]
percorreFilme filme [] = []
percorreFilme filme (h:t) 
  | (getTituloFilme h) == (getTituloFilme filme) = t
  | otherwise = [h] ++ percorreFilme filme t

atualizarFavoritos :: Usuario -> Filme -> IO Usuario
atualizarFavoritos user filme = do
  if (verificaSeEsta filme (getFilmesFav user)) then do
      us1 <- desfavoritarFilme user filme
      us <- favoritarFilme us1 filme
      return us
    else do
      return user

atualizarWatchList :: Usuario -> Filme -> IO Usuario
atualizarWatchList user filme = do
  if (verificaSeEsta filme (getWatch user)) then do
      us1 <- removeWatch user filme
      us <- addWatch us1 filme
      return us
    else do
      return user

atualizarAssistidos :: Usuario -> Filme -> IO Usuario
atualizarAssistidos user filme = do
  if (verificaSeEsta filme (getFilmesAssistidos user)) then do
      us1 <- removeAssistidos user filme
      us <- addAssistidos us1 filme
      return us
    else do
      return user

{-Recomendação de filmes. Recebe uma lista de Filmes e de Favoritos do usuário, recebe também as preferências do usuário quanto a genêros, atores e diretor. quantidade representa a quantidade de filmes que devem ser retornados.-}

--ok
{-Passa as entradas pra auxRecomenda-}
recomenda :: Int -> [Filme] -> Usuario -> [Filme]
recomenda quantidade filmesDoRep us = auxRecomenda (getFilmesFav us) filmesDoRep filmesDoRep quantidade [] us

--ok
{-
Retorna uma lista de filmes com as maiores notas segundo a função atribuiNota. O tamanho é definido pela quantidade ou pelo tamanho do repositório
1) Se quantidade de númeos a serem retornado é menor ou igual a 0 ou a lista usada na recursão estiver vazia, retorna a saidaArray
2) Se o filme já está na lista de saída ou na lista de favoritos, ele chama o próximo da lista
3) Por fim, chama a função maior e se chama recursivamente.
-}
auxRecomenda :: [Filme] -> [Filme] -> [Filme] -> Int -> [Filme] -> Usuario -> [Filme]
auxRecomenda _ [] _ _ saidaArray _ = saidaArray
auxRecomenda filmesFavoritos (y:ys) filmesDoRep quantidade saidaArray us
        | (quantidade <= 0) = saidaArray
        | (verificaSeEsta y saidaArray) || (verificaSeEsta y filmesFavoritos) = auxRecomenda filmesFavoritos (ys) filmesDoRep quantidade saidaArray us
        | otherwise = auxRecomenda filmesFavoritos ys filmesDoRep (quantidade - 1) (concat [saidaArray, [maior y filmesDoRep filmesFavoritos saidaArray us]]) us

--ok
{-Uma função auxiliar para verificar se o filme está no array.-}
verificaSeEsta :: Filme -> [Filme] -> Bool
verificaSeEsta _ [] = False
verificaSeEsta filme (y:ys)
        | ehIgual filme y = True
        | otherwise = verificaSeEsta filme (ys)

verificaSeEstaString :: String -> [String] -> Bool
verificaSeEstaString _ [] = False
verificaSeEstaString preferencia (y:ys)
        | preferencia == y = True
        | otherwise = verificaSeEstaString preferencia (ys)

--ok
{-
maiorNota :: Filme  -- ^ Filme de referência para comparar notas
          -> [Filme]  -- ^ Lista de filmes a serem comparados
          -> [Filme]  -- ^ Lista de filmes favoritos do usuário
          -> [Filme]  -- ^ Lista de filmes já selecionados como sugestões
          -> Usuario  -- ^ Usuário para obter o gosto pessoal
          -> Filme  -- ^ Filme com a maior nota encontrada
Usando verificações e a função atribuiNota ele retorna o filme com a maior nota
1) Se o array de filmes usado recursivamente está vazio, retorne a saida.
2) Se o filme x está na lista de favorito ou no array de saida, chama recursivamente o próximo do array para comparar com filme.
3) Se a nota do filme for maior ou igual ao filme x, então chame maior passando o próximo elemento do array do repositório.
4) Se chegar na quarta linha, então a nota de x é maior que a do filme e por isso chame recursivamente usando x como filme.
-}
maior :: Filme -> [Filme] -> [Filme] -> [Filme]-> Usuario -> Filme
maior filme [] filmesfav saidaArray us = filme
maior filme (x:xs) filmesfav saidaArray us
        | (verificaSeEsta x filmesfav) || (verificaSeEsta x saidaArray) = maior filme (xs) filmesfav saidaArray us
        | (atribuiNota filme (getGeneros us) (getDiretores us) (getAtores us)) >= (atribuiNota x(getGeneros us) (getDiretores us) (getAtores us)) = maior filme (xs) filmesfav saidaArray us
        | otherwise = maior x (xs) filmesfav saidaArray us

--ok
{-Uma função auxiliar para verificar se os filmes são iguais.-}
ehIgual :: Filme -> Filme -> Bool
ehIgual filme1 filme2 = (getTituloFilme filme1 == getTituloFilme filme2) && (getDataFilme filme1 == getDataFilme filme2)

--ok
{-
Usado por atribuiNota, trabalha em conjunto com similaridade para retornar a quantidade de elementos da lista de filme e da lista de gostos do usuário que possuem similaridade
Exemplo: O usuário possui 3 generos de filmes favortitos, "A", "B" e "C", e o filme possue como generos "A" e "B", o que esta função retorna é quantidade elementos da lista de filmes que são iguais aos gostos do usuário, nesse caso, 2.
-}
atribuiValor :: [String] -> [String] -> Int
atribuiValor [] _ = 0
atribuiValor (x:xs) dadosFilme = (similaridade x dadosFilme) + (atribuiValor xs dadosFilme)

--ok
{-
Atribui nota a um filme. para o total, generos e atores, cada um, valem 30% de particiáção na nota, diretor vale 20% e a nota do Imdb 20% 
nota1 e nota2 é basicamente uma regra de 3, onde 30.0 é o máximo, quanto mais generos e atores em comum, mais próximo dos 30.0.
Também são feitas conversões de Int pra Float para evitar erro de tipo, O Int a ser convertido representa quantos elementos da lista de generos ou atores tem em comum com as preferencias do usuario quanto a atores e generos.
nota3 chama a função similariadeDiretor retorna a nota correspondente ao diretor com base no diretor do filme e na lista de diretores fravoritos
nota4 nota do imdb associada ao filme
Por fim retorna em float correspondente a nota do filme.
-}
atribuiNota:: Filme -> [String] -> [String] -> [String] -> Float
atribuiNota filme generos diretores atores = (((fromIntegral (atribuiValor generos (getGenerosFilme filme)) :: Float) * 30.0) / (fromIntegral (length (getGenerosFilme filme)) :: Float)) + (((fromIntegral (atribuiValor atores (getAtoresFilme filme)) :: Float) * 30.0) / (fromIntegral (length (getAtoresFilme filme)) :: Float)) + ((fromIntegral (similaridade (getDiretorFilme filme) diretores) :: Float) * 20.0) + (((fromIntegral (getNotaImdbFilme filme) :: Float) / 100.0) * 20.0)

--ok
{-Retorna 1 se há correspondente entre os elementos comparados, faz isso até achar correspondente ou a lista ficar vazia.-}
similaridade :: String -> [String] -> Int
similaridade _ [] = 0
similaridade favorito (y:ys)
        | favorito == y = 1
        | otherwise = similaridade favorito (ys)