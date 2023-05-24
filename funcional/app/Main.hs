import Filme
import Pesquisar
import Dashboard
import RepositorioFilmes
import Usuario
import Util.Split
import Persistencia.PersistenciaFilmes
import Persistencia.PersistenciaUsersPreferences
import Text.CSV
import Data.Maybe (listToMaybe)



{-Função de inicialização do projeto. Lê o arquivo IMDB-Movie-Data.csv e UserPreferences.csv , com o resultado das leituras, instancia a função addAll , para que a aplicação siga seu fluxo (Filmes e Preferências do usuário são setadas para uso.). -}
main :: IO ()
main = do
  putStrLn "---------------------------------------------------------------"
  putStrLn "                 Bem vindo(a) ao CINEMATCH                     "
  putStrLn "---------------------------------------------------------------"
  let filmesSCV = "IMDB-Movie-Data.csv"
  let userPreferences = "UserPreferences.csv"
  resultadoFilmesCSV <- parseCSVFromFile filmesSCV
  resultadoUserPreferencesCSV <- parseCSVFromFile userPreferences
  case resultadoUserPreferencesCSV of 
    Right linhas1 -> do
      let generos = (linhas1 !! 0)
          diretores = (linhas1 !! 1)
          atores = (linhas1 !! 2)
          filmesFavoritos = (linhas1 !! 3)
          watchList = (linhas1 !! 4)
          filmesAssist = (linhas1 !! 5)
      case resultadoFilmesCSV of
        Right linhas -> do
          addAll linhas (RepositorioFilmes { filmes = [] }) (Usuario { generosFav = (take (length generos -1) generos)
                            , diretoresFav = (take (length diretores -1) diretores)
                            , atoresFav = (take (length atores -1) atores)
                            , filmesFav = [] 
                            , watchlist = []
                            , filmesAssistidos = []
                            }) filmesFavoritos watchList filmesAssist
  
                       
{-Função responsavel por exibir e receber (input) a opção do usuário sobre o que ele deseja usar da aplicação. Instância acoes com o valor recebido.-}
opcoes :: RepositorioFilmes -> Usuario -> IO ()
opcoes rep user = do
  putStrLn "++---------------------Escolha uma ação----------------------++"
  putStrLn " 1) Pesquisar"
  putStrLn " 2) Favoritar Gênero"
  putStrLn " 3) Favoritar Ator"
  putStrLn " 4) Favoritar Diretor"
  putStrLn " 5) Favoritar Filme"
  putStrLn " 6) Desfavoritar Filme"
  putStrLn " 7) Atribuir nota filme"
  putStrLn " 8) Recomendação"
  putStrLn " 9) Adicionar filme assistido"
  putStrLn " 10) Adicionar a lista de desejos"
  putStrLn " 11) Lista de diretores favoritos"
  putStrLn " 12) Lista de filmes que se deseja assistir"
  putStrLn " 13) Lista de generos favoritos"
  putStrLn " 14) Lista de atores favoritos"
  putStrLn " 15) Lista de filmes favoritos"
  putStrLn " 16) Lista de desejos"
  putStrLn " 17) Cadastrar Filme"
  putStrLn " 18) Dashboard"
  putStrLn " 19) Desfavoritar Gênero"
  putStrLn " 20) Desfavoritar Ator"
  putStrLn " 21) Desfavoritar Diretor"
  putStrLn " 22) EXIT PROGRAM"
  putStrLn "Opção escolhida : "
  opcao <- getLine
  putStrLn "++-----------------------------------------------------------++"
  if opcao == "22" then do
    putStrLn "Obrigado por usar o CINEMATCH!"
    salvaFilmesPersistentemente (getRepFilmes rep)
    salvaPreferenciasUsuarioPersistentemente (getGeneros user) (getDiretores user) (getAtores user) (getFilmesFav user) (getWatch user) (getFilmesAssistidos user)
    return ()
  else do
    novoRepo <- acoes opcao rep user
    return ()

{-Função que , de acordo com o valor recebido da função opções , irá realizar operações (instanciando as funções necessárias).-}
acoes :: String -> RepositorioFilmes -> Usuario -> IO ()
acoes cmd rep user
  | cmd == "1"     =  do
    selecaoPesquisa rep
    opcoes rep user
  | cmd == "2"     = do
    putStrLn "Qual gênero deseja favoritar : Action,Adventure,Horror,Animation,Fantasy,Comedy,Biography,Drama,Family,History,Sci-Fi,Thriller,Mystery,Crime,Western,Romance,War,Musical,Music,Sport"
    com <- getLine
    us <- (favoritarGenero user com)
    print (getGeneros us)
    opcoes rep us
  | cmd == "3"     = do
    putStrLn "Qual ator deseja favoritar : "
    com <- getLine
    us <- (favoritarAtor user com)
    print (getAtores us)
    opcoes rep us
  | cmd == "4"     = do
    putStrLn "Qual diretor deseja favoritar : "
    com <- getLine
    us <- (favoritarDiretor user com)
    print (getDiretores us)
    opcoes rep us
  | cmd == "5" = do
    putStrLn "Qual o título do Filme deseja favoritar : "
    nome <- getLine
    putStrLn "Qual a data de lançamento do Filme deseja favoritar : "
    lanc <- getLine
    let filmes = (getFilme (getRepFilmes rep) nome lanc)
        filme = listToMaybe filmes
    us <- maybe (putStrLn "Filme não encontrado" >> return user) (favoritarFilme user) filme
    print (getFilmesFav us)
    opcoes rep us
  | cmd == "6"      = do
    putStrLn "Qual o título do Filme que deseja desfavoritar : "
    nome <- getLine
    putStrLn "Qual a data de lançamento do Filme que deseja desfavoritar : "
    lanc <- getLine
    let filmes = getFilme (getRepFilmes rep) nome lanc
        filme = listToMaybe filmes
    us <- maybe (putStrLn "Filme não encontrado" >> return user) (desfavoritarFilme user) filme
    opcoes rep us
  | cmd == "7"     = do
    putStrLn "Qual o título do Filme que deseja atributar nota : "
    titulo <- getLine
    putStrLn "Qual a data de lançamento do Filme que deseja atributar nota : "
    dataLancamento <- getLine
    putStrLn "Qual a nota do filme : "
    nota <- getLine
    repo <- return $ mudaNota rep titulo dataLancamento (read nota :: Float)
    let filme = getFilme (getRepFilmes repo) titulo dataLancamento
    us <- atualizarFavoritos user (filme !! 0)
    us1 <- atualizarWatchList us (filme !! 0)
    us2 <- atualizarAssistidos us1 (filme !! 0)
    opcoes rep us2
  | cmd == "8"     = do
    putStrLn "Quantas recomendações deseja receber : "
    qtd <- readLn :: IO Int
    print(recomenda qtd (getRepFilmes rep) user)
    opcoes rep user
  | cmd == "9"       = do
    putStrLn "Qual o título do Filme deseja adicionar a lista de assistidos : "
    nome <- getLine
    putStrLn "Qual a data de lançamento do Filme deseja adicionar a lista de as : "
    lanc <- getLine
    let filmes = (getFilme (getRepFilmes rep) nome lanc)
        filme = listToMaybe filmes
    us <- maybe (putStrLn "Filme não encontrado" >> return user) (addAssistidos user) filme
    print (getFilmesAssistidos us)
    opcoes rep us
  | cmd == "10"      = do 
    putStrLn "Qual o título do Filme deseja adicionar a lista de desejos : "
    nome <- getLine
    putStrLn "Qual a data de lançamento do Filme deseja adicionar a lista de desejos : "
    lanc <- getLine
    let filmes = (getFilme (getRepFilmes rep) nome lanc)
        filme = listToMaybe filmes
    us <- maybe (putStrLn "Filme não encontrado" >> return user) (addWatch user) filme
    print (getWatch us)
    opcoes rep us
  | cmd == "11"     = do
    print(getDiretores user)
    opcoes rep user
  | cmd == "12"     = do
    print(getWatch user)
    opcoes rep user
  | cmd == "13"     = do
    print(getGeneros user)
    opcoes rep user
  | cmd == "14"     = do
    print(getAtores user)
    opcoes rep user
  | cmd == "15"     = do
    print(getFilmesFav user)
    opcoes rep user
  | cmd == "16"     = do
    print(getWatch user)
    opcoes rep user
  | cmd == "17"     = do
    putStrLn "Digite o nome do filme:"
    titulo <- getLine
    putStrLn "Digite o ano de lançamento do filme:"
    dataLancamento <- getLine
    repo <- existe titulo dataLancamento rep
    opcoes repo user
  | cmd == "18"     = do
    putStrLn(dashboardString user)
    opcoes rep user
  | cmd == "19"     = do
    putStrLn "Qual gênero deseja desfavoritar : "
    com <- getLine
    us <- (desfavoritarGenero user com)
    print (getGeneros us)
    opcoes rep us
  | cmd == "20"     = do
    putStrLn "Qual ator deseja desfavoritar : "
    com <- getLine
    us <- (desfavoritarAtor user com)
    print (getAtores us)
    opcoes rep us
  | cmd == "21"     = do
    putStrLn "Qual diretor deseja desfavoritar : "
    com <- getLine
    us <- (desfavoritarDiretor user com)
    print (getDiretores us)
    opcoes rep us
  | cmd == "22"    = do
    return()
  | otherwise      = do
    putStrLn "Comando inválido ou não implementado até o momento"
    opcoes rep user




{-No início da aplicação , adiciona todos os filmes do arquivo IMDB-Movie-Data.csv no repositório de filmes. Após isso , salva as preferencias do usuário e  instância a função opcoes.-}
addAll :: [[String]] -> RepositorioFilmes -> Usuario -> [String] -> [String] -> [String] -> IO ()
addAll [x] rep user favoritos watch assistidos = do
  favoritos <- return $ csvUsuario favoritos [] rep
  watch <- return $ csvUsuario watch [] rep
  assistidos <- return $ csvUsuario assistidos [] rep

  us <-  saveFilmeFavorito favoritos user
  us1 <- saveFilmeWatch watch us
  us2 <- saveFilmeAssistidos assistidos us1
  opcoes rep us2
addAll (x:xs) rep user favoritos watch assistidos = do
  let titulo = x !! 0
      generos = x !! 1
      descricao = x !! 2 
      diretor = x !! 3
      atores = x !! 4
      dataLancamento = x !! 5
      duracao = x !! 6
      notaImdb = x !! 7
      notaUsuaio = x !! 8
      filme = criarFilme titulo (split ',' generos) descricao diretor (split ',' atores) dataLancamento duracao (read notaImdb :: Int) (read notaUsuaio :: Float)
  addAll xs (addFilmeRepositorio rep filme) user favoritos watch assistidos
