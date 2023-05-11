module RepositorioFilmes where

import Filme
import Util.Split

{-Tipo Repositorio de Filmes. Possui uma lista de filmes do tipo Filme.-}
data RepositorioFilmes = RepositorioFilmes {
  filmes :: [Filme]
} deriving (Show)

{-Chama o construtor de Filme e insere os dados e retorna o filme.-}
criarFilme :: String -> [String] -> String -> String-> [String] -> String -> String -> Int -> Float -> Filme
criarFilme titulo generos descricao diretor atores dataLancamento duracao notaImdb notaUsuario =
  Filme { titulo = titulo, generos = generos, descricao = descricao, diretor = diretor, atores = atores, dataLancamento = dataLancamento, duracao = duracao, notaImdb = notaImdb, notaUsuario = notaUsuario }

{-Get do repositório, retorna uma lista de filmes do tipo Filme-}
getRepFilmes :: RepositorioFilmes -> [Filme]
getRepFilmes (RepositorioFilmes fs) = fs

{-Adiciona filme no repositório de filmes. Recebe um repositório e o filme a ser adicionado, concatena a lista  de filmes com o novo filme e retorna o resltado que é do tipo RepositorioFilmes. Esse repositório de saida terá o novo filme já inserido-}
addFilmeRepositorio :: RepositorioFilmes -> Filme -> RepositorioFilmes
addFilmeRepositorio repositorio novoFilme = RepositorioFilmes {filmes = concat [filmes repositorio, [novoFilme]]}

{-Exibe todos os filmes do repositório-}
exibirRep :: RepositorioFilmes -> IO ()
exibirRep rep = print rep

{-Adiciona um filme no repositório. Usa a função lerCriaFilme para ler os dados do filme e chama a função addFilmerepositorio para inserir o filme no repositório e retornar um repositório atualizado-}
addFilme :: String -> String -> RepositorioFilmes -> IO RepositorioFilmes
addFilme titulo dataLancamento rep = do
  oFilme <- lerCriaFilme titulo dataLancamento
  return (addFilmeRepositorio rep oFilme)

{-Função usada para ler os dados do filme , recebe o titulo e dataLançamento, cria e retornar um filme com os atributos inseridos.
Lê os dados e na ultima linha, istância o filme usando o criarFilme e passa os dados-}
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

{-Função auxiliar usada para verificar se um filme já existe.
Recebe titulo, e a dataLançamento do filme que se deseja instanciar, também recebe uma lista de filmes do repositório.
1) Se a lista do tipo Filme estiver vazia, então o filme ainda não está no repositório.
2) Usa a fução jaExiste que verifica se o filme da cabeça da lista tem nome e datalançamento iguais aos passados como parametro.
3) Se não são iguais, se chama recursivamente passando o resto da lista.-}
verificaSeExiste :: String -> String -> [Filme] -> Bool
verificaSeExiste _ _ [] = False
verificaSeExiste titulo dataLancamento (y:ys)
        | jaExiste titulo dataLancamento y = True
        | otherwise = verificaSeExiste titulo dataLancamento (ys)

{-Função auxiliar que verifica se o filme passado como parametro tem titulo e datalançamento iguas aos que também foram passados como parametro.-}
jaExiste :: String -> String -> Filme -> Bool
jaExiste titulo dataLancamento filme = (titulo == getTituloFilme filme) && (dataLancamento == getDataFilme filme)

{-Retorna um RepositorioFilmes. Recebe duas Strings e um RepositoriodeFilmes.
1) Usa o verificaSeExiste que retorna um Bool, idicando se o filme existe, se o filme existe, retorna o RepositórioFilmes passado como parametro; assim não adiciona o mesmo filme duas vezes.
2) Se chega nesse ponto, então o filme não existe, por isso o filme deve ser adicionado ao repositório de filmes.-}
existe :: String -> String -> RepositorioFilmes -> IO RepositorioFilmes
existe titulo dataLancamento rep
  | verificaSeExiste titulo dataLancamento (getRepFilmes rep) = return rep
  | otherwise = addFilme titulo dataLancamento rep

{-Recebe uma lista de filmes, nome que se refere ao titulo, lanc que se refere a dataLançamento e retorna uma lista com 1 filme, correpondente a busca na lista.
1) Se a lista de filmes estiver vazia, retorna uma lista vazia.
2) Compara titulo do filme com nome e data do filme com lanc se forem ambos iguais, retorna o filme dentro de um array.
3) Chama o getFilme recursivo passando o resto da lista.-}
getFilme :: [Filme] -> String -> String -> [Filme]
getFilme [] _ _ = []
getFilme (x:xs) nome lanc
  | (((getTituloFilme x) == nome) && ((getDataFilme x) == lanc))  = [x]
  | otherwise                    = getFilme xs nome lanc

{-Muda a nota de usuário de um filme.
Recebe o repositório, titulo, dataLançamento e a nova nota; retorna um RepositorioFilmes.
1) Usa a função verificaSeExiste que diz se o filme existe, se sim, chama a função atualizaNota que retorna um RepositorioFilmes com a nota do filme atualizada.
2) Se o filme não existe, retorna o repositório passado como parametro.-}
mudaNota :: RepositorioFilmes -> String -> String -> Float -> RepositorioFilmes
mudaNota rep titulo dataLancamento nota
  | verificaSeExiste titulo dataLancamento (getRepFilmes rep) = atualizaNota rep nota titulo dataLancamento 
  | otherwise = rep

{-Atualiza a nota de um filme.
Recebe um RepositorioFilmes, um float, duas Strings; retorna um RepositorioFilmes.
Chama a função retornaFilmes, atualizando a nota do filme e retornando o repositório atualizado.-}
atualizaNota :: RepositorioFilmes -> Float -> String -> String -> RepositorioFilmes
atualizaNota repo nota titulo dataLancamento = repo { filmes = (retornaFilmes titulo dataLancamento nota [] (getRepFilmes repo)) }

{-Retorna uma lista de filmes.
Recebe um titulo, datalançamento, nova nota, uma lista que é passada como vazia na chamada e uma lista de filmes do repositório.
1) Verifica se um filme já existe, se sim, concatena a lista de filmes que já foram verificados não serem o filme buscado, com o filme procurado e atulizado e também com o resto da lista de filmes
EX: [left ++ filme atualizado ++ right]
2) Se não encontrou o filme, chama recursivamento o próximo elemento da lista, comcatenando o filme y com a lista de japassou.
Como a existencia do filme já é verificada anteriormente, então esta função se resume a encontrar o filme, atualizar a nota e retornar a lista atualizada.-}
retornaFilmes :: String -> String -> Float -> [Filme] -> [Filme] -> [Filme]
retornaFilmes titulo dataLancamento newNota jaPassou (y:ys)
  | jaExiste titulo dataLancamento y = concat [jaPassou, [(atualizaNotaUsuario y newNota)], ys]
  | otherwise = retornaFilmes titulo dataLancamento newNota (concat [jaPassou, [y]]) (ys)

{-Atualiza a nota do filme e reorna o filme atualizado.-}
atualizaNotaUsuario :: Filme -> Float -> Filme
atualizaNotaUsuario filme novaNota = filme { notaUsuario = novaNota }

{-Apartir de um elemento da lista de Strings, a função encontra o filme que tem titulo e data correspondentes e adiciona na lista de saida.
1) Se a lista de estiver vazia, retorna a lista saidaArray.
2) Chama a si mesmo recursivamente, passando saidaArray concatenado com returnSegundo como lista de saida.-}
csvUsuario :: [String] -> [Filme] -> RepositorioFilmes -> [Filme]
csvUsuario [] saidaArray _ = saidaArray
csvUsuario (x:xs) saidaArray rep = csvUsuario xs (saidaArray ++ (returnSegundo (split '_' x) rep)) rep

{-Retorna uma lista de filmes com um único filme.
Usa o getFilme para encontrar o filme correspondente no repositório de filmes.-}
returnSegundo :: [String] -> RepositorioFilmes -> [Filme]
returnSegundo (x:xs) rep = getFilme (getRepFilmes rep) x (re xs) 

{-Retorna o primeiro elemento da lista.-}
re :: [String] -> String
re (x:_) = x