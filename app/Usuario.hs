module Usuario where

import Filme
import RepositorioFilmes
import Util.Split
{-# LANGUAGE BangPatterns #-}

{-Tipo usuário, guarda as informações de gostos do usuário, sendo elas: os generos favoritos, em String os diretor favoritos
os atores favoritos, os filmes favoritos, os filmes assistidos e os filmes que quer assistir(watch list)-}

data Usuario = Usuario {
    generosFav :: [String],
    diretoresFav :: [String],
    atoresFav :: [String],
    filmesFav :: [Filme],
    watchlist :: [Filme],
    filmesAssistidos :: [Filme]
}

{-Get dos filmes que o usuario quer assistir, retornando a watch list do usuario-}
getWatch :: Usuario -> [Filme]
getWatch (Usuario { watchlist = w}) = w

{-Get dos generos favoritos do usuário, retornando generos favoritos do usuário do usuario-}
getGeneros :: Usuario -> [String]
getGeneros (Usuario { generosFav = gn}) = gn

{-Get dos diretores favoritos do usuário, retornando diretores favoritos do usuário do usuario-}
getDiretores :: Usuario -> [String]
getDiretores (Usuario { diretoresFav = dr}) = dr

{-Get dos atores favoritos do usuário, retornando atores favoritos do usuário do usuario-}
getAtores :: Usuario -> [String]
getAtores (Usuario { atoresFav = at}) = at

{-Get dos filmes favoritos do usuário, retornando filmes favoritos do usuário do usuario-}
getFilmesFav :: Usuario -> [Filme]
getFilmesFav (Usuario { filmesFav = fs}) = fs

{-Get dos  filmes  assistidos do usuário, retornando filmes assistidos do usuário do usuario-}
getFilmesAssistidos :: Usuario -> [Filme]
getFilmesAssistidos (Usuario { filmesAssistidos = fa } ) = fa


{- Adiciona um filme na lista de desejos do usuário.
Primeiro ele verifica se o filme já esta na lista de desejos, se estiver exibirá um alerta ao usuário
caso não esteja será adicionado a lista de desejos-}
addWatch:: Usuario -> Filme -> IO Usuario
addWatch us filme = do
  if (verificaSeEsta filme (getWatch us)) then do
    putStrLn "O filme já está na lista de desejos!"
    return us
  else do
    let watchAtualizado = (filme : getWatch us)
    return us { watchlist = watchAtualizado }
  
{- Remove um filme na lista de desejos do usuário.
  Primeiro a função checa se o filme esta na lista de Desejos, se tiver, ele é removido
  Caso não, ele alerta um erro ao usuário, avisando que aquele filme não esta na lista de desejos-}
removeWatch :: Usuario -> Filme -> IO Usuario
removeWatch us filme = do
  if (verificaSeEsta filme (getWatch us)) then do
    let watchList = percorreFilme filme (getWatch us)
    return us { watchlist = watchList }
  else do
    putStrLn "O filme não estava na lista de desejos!"
    return us

{- Adiciona um filme na lista de filmes assistidos do usuário.
   Primeiro ele verifica se o filme já esta na lista de assistidps, se estiver exibirá um alerta ao usuário
   caso não esteja será adicionado a lista de assistidos-}
addAssistidos :: Usuario -> Filme -> IO Usuario
addAssistidos us filme = do
  if (verificaSeEsta filme (getFilmesAssistidos us)) then do
    putStrLn "O filme já está na lista de assistidos!"
    return us
  else do
    let filmesAssistidos1 = (filme : getFilmesAssistidos us)
    return us { filmesAssistidos = filmesAssistidos1 }

{- Remove um filme na lista de filmes assistidos do usuário.
  Primeiro a função checa se o filme esta na lista de assistidos, se tiver, ele é removido
  Caso não, ele alerta um erro ao usuário, avisando que aquele filme não esta na lista de assistidos-}
removeAssistidos :: Usuario -> Filme -> IO Usuario
removeAssistidos us filme = do
  if (verificaSeEsta filme (getFilmesAssistidos us)) then do
    let assistidos = percorreFilme filme (getFilmesAssistidos us)
    return us { filmesAssistidos = assistidos }
  else do
    putStrLn "O filme não estava na lista de assistidos!"
    return us

{- Adiciona um filme na lista de filmes favoritos do usuário.
   Primeiro ele verifica se o filme já esta na lista de favoritos, se estiver exibirá um alerta ao usuário
   caso não esteja será adicionado a lista de filmes favoritos-}
favoritarFilme :: Usuario -> Filme -> IO Usuario
favoritarFilme us filme = do
  if (verificaSeEsta filme (getFilmesFav us)) then do
    putStrLn "Filme já está nos favoritos!"
    return us
  else do
    let filmesFavoritosAtualizados = (filme : getFilmesFav us)
    return us { filmesFav = filmesFavoritosAtualizados }

{- Remove um filme na lista de filmes favoritos do usuário.
   Primeiro a função checa se o filme esta na lista de favoritos, se tiver, ele é removido
   Caso não, ele alerta um erro ao usuário, avisando que aquele filme não esta na lista de favoritos-}
desfavoritarFilme :: Usuario -> Filme -> IO Usuario
desfavoritarFilme us filme = do
  if (verificaSeEsta filme (getFilmesFav us)) then do
    let filmesFavoritosAtualizados = percorreFilme filme (getFilmesFav us)
    return us { filmesFav = filmesFavoritosAtualizados }
  else do
    putStrLn "O filme não estava na lista de favoritos!"
    return us

{- Adiciona um Ator na lista de atores favoritos do usuário.
   Primeiro a função checa se o ator já está favoritado, se estiver, é exibido um alerta ao usuario
   caso não, o ator é adicionado a lista de favoritos-}
favoritarAtor :: Usuario -> String -> IO Usuario
favoritarAtor us ator = do
  if (verificaSeEstaString ator (getAtores us)) then do
    putStrLn "O ator já está na lista de favoritos"
    return us
  else do
    let atoresFavoritosAtualizados = (ator : getAtores us)
    return us { atoresFav = atoresFavoritosAtualizados }

{- Remove um Ator na lista de atores favoritos do usuário.
   a função percorre a  lista de atores favoritos removendo os atores com o nome que se deseja remover-}
desfavoritarAtor :: Usuario -> String -> IO Usuario
desfavoritarAtor us nome = do
  let atoresFavoritosAtualizados = percorreString nome (getAtores us) 
  return us { atoresFav = atoresFavoritosAtualizados }

{- Favorita um Gênero na lista de generos favoritos do usuário.
   Primeiro a função checa se o genero é aceito, caso não seja, alerta-se ao usuarios,
   após isso checa se já está favoritado, se estiver, é exibido um alerta ao usuario
   caso não, o genero é adicionado a lista de generos favoritos-}
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

{- Desfavorita um Gênero na lista de generos favoritos do usuário.
a função percorre a  lista de generos favoritos removendo os generos com o nome que se deseja remover-}
desfavoritarGenero :: Usuario -> String -> IO Usuario
desfavoritarGenero us genero = do
  let generosFavoritosAtualizados = percorreString genero (getGeneros us)
  return us { generosFav = generosFavoritosAtualizados }

{- Favorita um Diretor na lista de diretores favoritos do usuário.
   Primeiro a função checa se o diretor já está favoritado, se estiver, é exibido um alerta ao usuario
   caso não, o diretor é adicionado a lista de diretores favoritos-}
favoritarDiretor :: Usuario -> String -> IO Usuario
favoritarDiretor us diretor = do
  if (verificaSeEstaString diretor (getDiretores us)) then do
    putStrLn "O diretor já está na lista de favoritos!"
    return us
  else do
    let diretoresFavoritosAtualizados = (diretor : getDiretores us)
    return us { diretoresFav = diretoresFavoritosAtualizados }

{- Desfavorita um Diretor na lista de diretores favoritos do usuario.
a função percorre a  lista de diretores favoritos removendo os diretors com o nome que se deseja remover-}  
desfavoritarDiretor :: Usuario -> String -> IO Usuario
desfavoritarDiretor us diretor = do
  let diretoresFavoritosAtualizados = percorreString diretor (getDiretores us)
  return us { diretoresFav = diretoresFavoritosAtualizados }

{-Metodo auxiliar que remove da lista as strings iguais as passadas
  a função olha se o head da lista e igual a string passada, se nao for, chama a funcao para o tail e concatena 
  com a head, se for, chama a funcao para o tail e NAO CONCETENA com a head-}
percorreString :: String -> [String] -> [String]
percorreString nome [] = []
percorreString nome (h:t) 
  | h == nome   = percorreString nome t
  | otherwise   = [h] ++ percorreString nome t

{-Metodo auxiliar que remove da lista os filmes iguais as passadas
  a função olha se o head da lista e igual ao filme passado, sendo igual se tiver o mesmo ano e titulo, se nao for, chama a funcao para o tail e concatena 
  com a head, se for, chama a funcao para o tail e NAO CONCETENA com a head-}
percorreFilme :: Filme -> [Filme] -> [Filme]
percorreFilme filme [] = []
percorreFilme filme (h:t) 
  | (getTituloFilme h) == (getTituloFilme filme) = t
  | otherwise = [h] ++ percorreFilme filme t


{-Função usada para favoritar e desfavoritar os filmes favoritos do usuário. Essa função é necessária pois, caso atribuirmos uma nota a um filme e esse filme estiver em favoritos do usuário, sua nota será atualizada.
  Assim a função olha se o filme esta favoritado, se tiver remove ele dos favoritos e adiciona a nova versão dele com a nota-}
atualizarFavoritos :: Usuario -> Filme -> IO Usuario
atualizarFavoritos user filme = do
  if (verificaSeEsta filme (getFilmesFav user)) then do
      us1 <- desfavoritarFilme user filme
      us <- favoritarFilme us1 filme
      return us
    else do
      return user

{-Função usada para favoritar e desfavoritar os filmes da lista de desejos do usuário. Essa função é necessária pois, caso atribuirmos uma nota a um filme e esse filme estiver na lista de desejos do usuário, sua nota será atualizada.
  Assim a função olha se o filme esta na watch lista, se tiver remove ele dela e adiciona a nova versão dele com a nota-}
atualizarWatchList :: Usuario -> Filme -> IO Usuario
atualizarWatchList user filme = do
  if (verificaSeEsta filme (getWatch user)) then do
      us1 <- removeWatch user filme
      us <- addWatch us1 filme
      return us
    else do
      return user

{-Função usada para favoritar e desfavoritar os filmes da lista de filmes assistidos do usuário. Essa função é necessária pois, caso atribuirmos uma nota a um filme e esse filme estiver na lista de filmes de assistidos do usuário, sua nota será atualizada.
  Assim a função olha se o filme esta na lista de assistidos, se tiver remove ele dos assistidos e adiciona a nova versão dele com a nota-}
atualizarAssistidos :: Usuario -> Filme -> IO Usuario
atualizarAssistidos user filme = do
  if (verificaSeEsta filme (getFilmesAssistidos user)) then do
      us1 <- removeAssistidos user filme
      us <- addAssistidos us1 filme
      return us
    else do
      return user


{-Salva uma lista de filmes em favoritos do usuário. Usada na inicialização das preferencias do usuário (lidas no UserPreferences.csv)
para isso ele passa uma lista de filmes, se ela for vazia retorna o usuário, se não ela favoritrá o filme e chamará a função para o tail.-}
saveFilmeFavorito :: [Filme] -> Usuario -> IO Usuario
saveFilmeFavorito [] user = return user
saveFilmeFavorito (x:xs) user = favoritarFilme user x >>= saveFilmeFavorito xs

{-Salva uma lista de filmes na lista de desejos do usuário. Usada na inicialização das preferencias do usuário (lidas no UserPreferences.csv)
para isso ele passa uma lista de filmes, se ela for vazia retorna o usuário, se não  coloca  o filme na watch list e chamará a função para o tail..-}
saveFilmeWatch :: [Filme] -> Usuario -> IO Usuario
saveFilmeWatch [] user = return user
saveFilmeWatch (x:xs) user = addWatch user x >>= saveFilmeWatch xs

{-Salva uma lista de filmes em filmes assistidos do usuário. Usada na inicialização das preferencias do usuário (lidas no UserPreferences.csv.)
para isso ele passa uma lista de filmes, se ela for vazia retorna o usuário, se não coloca  o filme nos assitidos e chamará a função para o tail..-}
saveFilmeAssistidos :: [Filme] -> Usuario -> IO Usuario
saveFilmeAssistidos [] user = return user
saveFilmeAssistidos (x:xs) user = addAssistidos user x >>= saveFilmeAssistidos xs

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
{-Uma função auxiliar para verificar se o filme está no array.
se passar uma lista vazia retorna false, se nao, se o head for igual ao buscado retorna true, se nao chamara
a funcao recursivamente para a tail-}
verificaSeEsta :: Filme -> [Filme] -> Bool
verificaSeEsta _ [] = False
verificaSeEsta filme (y:ys)
        | ehIgual filme y = True
        | otherwise = verificaSeEsta filme (ys)

{-Uma função auxiliar para verificar se a string está no array.
se passar uma lista vazia retorna false, se nao, se o head for igual ao buscado retorna true, se nao chamara
a funcao recursivamente para a tail-}
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
{-Uma função auxiliar para verificar se os filmes são iguais.
sendo eles iguais se tiverem o mesmo titulo e data-}
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