--Estúdio: (idEstúdio, nome, paísOrigem, dataFundação, email)
--Obra: (idObra, título, descrição, genero, tipoObra, dataLançamento, classificacaoIndicativa, orçamento, idEstudio)
--Elenco: (idPessoa, nome, nacionalidade, dataNasc)
--Elenco_obra(idPessoa, idObra, funcao, salario, bonus) 
--Plano: (idPlano, tipoPlano, valorMensal, qualidadeMax, maxTelas, exibeanuncios)
--Usuário: (idUsuario, nome, email, senha, idPlano)
--Perfil: (idPerfil, nomePerfil, tipoPerfil, idUsuario)
--Anunciante: (idAnunciante, nomeEmpresa, cnpj, email)
--Anuncio: (idAnuncio, titulo, duracaoSegundos, videoUrl, idAnunciante)

CREATE TABLE "Estudio"( 
    idEstudio INT PRIMARY KEY,
    nome VARCHAR(100)NOT NULL,
    paisOrigem VARCHAR(100) NOT NULL,
    dataFundacao DATE NOT NULL,
    email VARCHAR(100) UNIQUE
);