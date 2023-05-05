module Usuario where

import Filme
import RepositorioFilmes
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

getGeneros :: Usuario -> [String]
getGeneros (Usuario { generosFav = gn}) = gn

getDiretores :: Usuario -> [String]
getDiretores (Usuario { diretoresFav = dr}) = dr

getAtores :: Usuario -> [String]
getAtores (Usuario { atoresFav = at}) = at

getFilmesFav :: Usuario -> [Filme]
getFilmesFav (Usuario { filmesFav = fs}) = fs

{-Adicionam itens nas listas de favoritos-}

favoritarAtor :: Usuario -> String -> IO Usuario
favoritarAtor us ator = do
  let atoresFavoritosAtualizados = (ator : getAtores us)
  return us { atoresFav = atoresFavoritosAtualizados }

favoritarGenenero :: Usuario -> String -> IO Usuario
favoritarGenenero us genero = do
  let generosFavoritosAtualizados = (genero : getGeneros us)
  return us { generosFav = generosFavoritosAtualizados }

favoritarDiretor :: Usuario -> String -> IO Usuario
favoritarDiretor us diretor = do
  let diretoresFavoritosAtualizados = (diretor : getDiretores us)
  return us { diretoresFav = diretoresFavoritosAtualizados }

favoritarFilme :: Usuario -> Filme -> IO Usuario
favoritarFilme us filme = do
  let filmesFavoritosAtualizados = (filme : getFilmesFav us)
  return us { filmesFav = filmesFavoritosAtualizados }

{-Recomendação de filmes. Recebe uma lista de Filmes e de Favoritos do usuário, recebe também as preferências do usuário quanto a genêros, atores e diretor. quantidade representa a quantidade de filmes que devem ser retornados.-}

--ok
{-Passa as entradas pra auxRecomenda-}
recomenda :: Int -> [Filme] -> [Filme] -> Usuario -> [Filme]
recomenda quantidade filmesFavoritos filmesDoRep us = auxRecomenda filmesFavoritos filmesDoRep filmesDoRep quantidade [] us

--ok
{-
Retorna uma lista de filmes com as maiores notas segundo a função atribuiNota. O tamanho é definido pela quantidade ou pelo tamanho do repositório
1) Se quantidade de númeos a serem retornado é menor ou igual a 0 ou a lista usada na recursão estiver vazia, retorna a saida
2) Se o filme já está na lista de saída, ele chama o próximo da lista
3) Se o filme não está na lista de favoritos, então chama a função maior e se chama recursivamente
-}
auxRecomenda :: [Filme] -> [Filme] -> [Filme] -> Int -> [Filme] -> Usuario -> [Filme]
auxRecomenda filmesFavoritos (y:ys) filmesDoRep quantidade saida us
        | (quantidade <= 0 || length (y:ys) == 0) = saida
        | (verificaSeEsta y saida) || (verificaSeEsta y filmesFavoritos) = auxRecomenda filmesFavoritos (ys) filmesDoRep quantidade saida us
        | otherwise = [(maior y filmesDoRep filmesFavoritos y saida us)] ++ (auxRecomenda filmesFavoritos ys filmesDoRep (quantidade - 1) saida us)

--ok
{-Uma função auxiliar para verificar se o filme está no array-}
verificaSeEsta :: Filme -> [Filme] -> Bool
verificaSeEsta _ [] = False
verificaSeEsta filme (y:ys)
        | ehIgual filme y = True
        | otherwise = verificaSeEsta filme (ys)

--ok
{-
Usando verificações e a função atribuiNota ele retorna o filme com a maior nota
1) Se o array de filmes usado recursivamente está vazio, retorne a saida
4) Se o filme x está na lista de favorito ou no array de saida, chama recursivamente o próximo do array para comparar com filme
3) Se a nota do filme for maior ou igual ao filme x, então chame maior passando o próximo elemento do array do repositório
4) Se chegar na quarta linha, então a nota de x é maior que a do filme e por isso chame recursivamente usando x como filme
-}
maior :: Filme -> [Filme] -> [Filme] -> Filme -> [Filme]-> Usuario -> Filme
maior filme (x:xs) filmesfav saida saidaArray us
        | length (x:xs) <= 0 = saida
        | (verificaSeEsta x filmesfav) || (verificaSeEsta x saidaArray) = maior filme (x:xs) filmesfav saida saidaArray us
        | (atribuiNota filme (getGeneros us) (getDiretores us) (getAtores us)) >= (atribuiNota x(getGeneros us) (getDiretores us) (getAtores us)) = maior filme (xs) filmesfav saida saidaArray us
        | otherwise = maior x (xs) filmesfav x saidaArray us

--ok
{-Uma função auxiliar para verificar se os filmes são iguais-}
ehIgual :: Filme -> Filme -> Bool
ehIgual filme filmeFav = (getTituloFilme filme == getTituloFilme filmeFav) && (getDataFilme filme == getDataFilme filmeFav)

--ok
{-Usado por atribuiNota, trabalha em conjunto com similaridade para retornar a quantidade de elementos do array de filme e do array de gostos do usuário-}
atribuiValor :: [String] -> [String] -> Int
atribuiValor [] _ = 0
atribuiValor (x:xs) dadosFilme = (similaridade x dadosFilme) + (atribuiValor xs dadosFilme)

--ok
{-
Atribui nota a um filme. para o total, generos e atores valem 30% da nota, diretor vale 20% e a soma da nota do Imdb e usuarios vale 20% 
nota1 e nota2 é basicamente uma regra de 3 onde 30.0 é o máximo, quanto mais generos e atores em comum, mais próximo dos 30.0.
Também são feitas conversões de Int pra Float para evitar erro de tipo, O inte representa quantod elementos do array de generos ou atores tem em comum com as preferencias do usuario.
nota3 chama a função similariadeDiretor retorna a nota correspondente ao diretor com base no diretor do filme e no array de diretores fravoritos
nota4 soma ota de usuarios e nota do imdb
Por fim retorna em float a nota correspondente ao filme.
-}
atribuiNota:: Filme -> [String] -> [String] -> [String] -> Float
atribuiNota filme generos diretores atores = (((fromIntegral (atribuiValor generos (getGenerosFilme filme)) :: Float) * 30.0) / (fromIntegral (length (getGenerosFilme filme)) :: Float)) + (((fromIntegral (atribuiValor atores (getAtoresFilme filme)) :: Float) * 30.0) / (fromIntegral (length (getAtoresFilme filme)) :: Float)) + (similaridadeDiretor diretores (getDiretorFilme filme)) + ((((fromIntegral (getNotaImdbFilme filme) :: Float) / 10.0)*20.0)/10)

--ok
{-Retorna 1 se há correspondente entre o elemento comparado-}
similaridade :: String -> [String] -> Int
similaridade _ [] = 0
similaridade favorito (y:ys)
        | favorito == y = 1
        | otherwise = similaridade favorito (ys)

--ok
{-Similaridade do diretor. Verifica se o diretor do filme está no array de diretores favoritod-}
similaridadeDiretor :: [String] -> String -> Float
similaridadeDiretor [] _ = 0.0
similaridadeDiretor (x:xs) diretor
        | x == diretor = 20.0
        | otherwise = similaridadeDiretor (xs) diretor
    