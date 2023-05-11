module RepositorioFilmes where

import Filme
import Util.Split



{-Tipo Repositorio de Filmes. Guarda um array de filmes.-}

data RepositorioFilmes = RepositorioFilmes {
  filmes :: [Filme]
} deriving (Show)

{-Chama o construtor de Filme e insere os dados-}
criarFilme :: String -> [String] -> String -> String-> [String] -> String -> String -> Int -> Float -> Filme
criarFilme titulo generos descricao diretor atores dataLancamento duracao notaImdb notaUsuario =
  Filme { titulo = titulo, generos = generos, descricao = descricao, diretor = diretor, atores = atores, dataLancamento = dataLancamento, duracao = duracao, notaImdb = notaImdb, notaUsuario = notaUsuario }

{-Get do repositório, retorna a lista de filmes-}
getRepFilmes :: RepositorioFilmes -> [Filme]
getRepFilmes (RepositorioFilmes fs) = fs

{-Adiciona filme no repositório. Recebe um repositório e o filme a ser adicionado, concatena o array de filmes com o novo filme dentro do repositório e retorna o resltado que é um RepositorioFilmes-}
addFilmeRepositorio :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmeRepositorio repositorio novoFilme = RepositorioFilmes {filmes = concat [filmes repositorio, [novoFilme]]}

{-Exibe todos os filmes do repositório-}
exibirRep :: RepositorioFilmes -> IO ()
exibirRep rep = print rep

{-Adiciona um filme no repositório. Usa a função lerCriaFilme para ler os dados do filme e , assim , adicioná-los ao repositório-}
addFilme :: String -> String -> RepositorioFilmes -> IO RepositorioFilmes
addFilme titulo dataLancamento rep = do
  oFilme <- lerCriaFilme titulo dataLancamento
  return (addFilmeRepositorio rep oFilme)

{-Função usada para ler os dados do filme , criar e retornar um filme com os atributos lidos-}
lerCriaFilme :: String -> String -> IO Filme
lerCriaFilme titulo dataLancamento = do
  putStrLn "Digite os gêneros do filme (separados por espaço):"
  generos <- getLine
  putStrLn "Digite a descrição do filme:"
  descricao <- getLine
  putStrLn "Digite o nome do diretor do filme:"
  diretor <- getLine
  putStrLn "Digite os nomes dos atores do filme (separados por , ):"
  atores <- getLine
  putStrLn "Digite a duração do filme (em minutos):"
  duracao <- getLine
  putStrLn "Digite a nota do filme no IMDb (entre 0 e 100):"
  notaImdb <- getLine
  putStrLn "Digite a nota do filme na sua opiniao (entre 0.0 e 10.0):"
  notaUsuario <- getLine
  let filme = criarFilme titulo (split ' ' generos) descricao diretor (split ',' atores) dataLancamento duracao (read notaImdb :: Int) (read notaUsuario :: Float)
  return filme

verificaSeExiste :: String -> String -> [Filme] -> Bool
verificaSeExiste _ _ [] = False
verificaSeExiste titulo dataLancamento (y:ys)
        | jaExiste titulo dataLancamento y = True
        | otherwise = verificaSeExiste titulo dataLancamento (ys)

jaExiste :: String -> String -> Filme -> Bool
jaExiste titulo dataLancamento filme = (titulo == getTituloFilme filme) && (dataLancamento == getDataFilme filme)

existe :: String -> String -> RepositorioFilmes -> IO RepositorioFilmes
existe titulo dataLancamento rep
  | verificaSeExiste titulo dataLancamento (getRepFilmes rep) = return rep
  | otherwise = addFilme titulo dataLancamento rep

getFilme :: [Filme] -> String -> String -> [Filme]
getFilme [] _ _ = []
getFilme (x:xs) nome lanc
  | (((getTituloFilme x) == nome) && ((getDataFilme x) == lanc))  = [x]
  | otherwise                    = getFilme xs nome lanc

mudaNota :: RepositorioFilmes -> String -> String -> Float -> RepositorioFilmes
mudaNota rep titulo dataLancamento nota
  | verificaSeExiste titulo dataLancamento (getRepFilmes rep) = atualizaNota rep nota titulo dataLancamento 
  | otherwise = rep

atualizaNota :: RepositorioFilmes -> Float -> String -> String -> RepositorioFilmes
atualizaNota repo nota titulo dataLancamento = repo { filmes = (retornaFilmes titulo dataLancamento nota [] (getRepFilmes repo)) }

retornaFilmes :: String -> String -> Float -> [Filme] -> [Filme] -> [Filme]
retornaFilmes titulo dataLancamento newNota jaPassou (y:ys)
        | jaExiste titulo dataLancamento y = concat [jaPassou, [(atualizaNotaUsuario y newNota)], ys]
        | otherwise = retornaFilmes titulo dataLancamento newNota (concat [jaPassou, [y]]) (ys)

atualizaNotaUsuario :: Filme -> Float -> Filme
atualizaNotaUsuario filme novaNota = filme { notaUsuario = novaNota }

csvUsuario :: [String] -> [Filme] -> RepositorioFilmes -> [Filme]
csvUsuario [] saidaArray _ = saidaArray
csvUsuario (x:xs) saidaArray rep = csvUsuario xs (saidaArray ++ (returnSegundo (split '_' x) rep)) rep

returnSegundo :: [String] -> RepositorioFilmes -> [Filme]
returnSegundo (x:xs) rep = getFilme (getRepFilmes rep) x (re xs) 

re :: [String] -> String
re (x:_) = x