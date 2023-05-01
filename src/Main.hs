import Filme
import RepositorioFilmes

main :: IO ()
main = do
    let repositorio = RepositorioFilmes { filmes = [] }
    let filme1 = addFilme "Meu Filme" ["Drama", "Ação"] "Um filme incrível" "Eu mesmo" ["Eu mesmo", "Meu amigo"] "2023" "120" 4.5 "1000" "1.2" 8
    let novoRepositorio = addFilmeRepositorio repositorio filme1
    print novoRepositorio
