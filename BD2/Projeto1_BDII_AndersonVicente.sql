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

CREATE TABLE "Obra"( 
    idObra INT PRIMARY KEY,
    titulo VARCHAR(100)NOT NULL,
    sinopse VARCHAR(300) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    tipoObra VARCHAR(100) NOT NULL,
    dataLançamento DATE NOT NULL,
    classificacaoIndicativa CHAR(2) NOT NULL,
    orçamento DECIMAL (10,2) NOT NULL,
    idEstudio INT,

    CONSTRAINT fk_estudio FOREIGN KEY(idEstudio) REFERENCES Estudio(idEstudio)
);

CREATE TABLE "Elenco"( 
    idObra INT PRIMARY KEY,
    idPessoa VARCHAR(100)NOT NULL,
    nacionalidade VARCHAR(30) NOT NULL,
    dataNasc DATE NOT NULL
);

CREATE TABLE "Elenco_Obra"( 
    idObra INT,
    idPessoa INT,
    funcao VARCHAR(30) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2),

    CONSTRAINT fk_obra FOREIGN KEY(idObra) REFERENCES Obra(idObra),
    CONSTRAINT fk_pessoa FOREIGN KEY(idPessoa) REFERENCES Elenco(idPessoa),
    CONSTRAINT pk_composta PRIMARY KEY(idObra, idPessoa)
);

CREATE TABLE "Plano"(
    idPlano INT PRIMARY KEY,
    tipoPlano VARCHAR(10) NOT NULL,
    valorMensal DECIMAL(4,2) NOT NULL,
    qualidadeMax VARCHAR(5) NOT NULL,
    maxTelas INT NOT NULL,
    exibeAnuncios CHAR(3)
);

CREATE TABLE "Usuario"(
    idUsuario INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(10) NOT NULL,
    idPlano INT,
    
    CONSTRAINT fk_plano FOREIGN KEY (idPlano) REFERENCES Plano(idPlano)
);

CREATE TABLE "Perfil"(
    idPerfil INT PRIMARY KEY,
    nomePerfil VARCHAR(100) NOT NULL,
    tipoPerfil VARCHAR(100) NOT NULL,
    idUsuario INT,
    
    CONSTRAINT fk_usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE "Anunciante"(
    idAnunciante INT PRIMARY KEY,
    nomeEmpresa VARCHAR(100) NOT NULL,
    tipoCNPJ VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
);

CREATE TABLE "Anuncio"(
    idAnuncio INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    duracaoSegundos INT NOT NULL,
    videoUrl VARCHAR(100) NOT NULL UNIQUE,
    idAnunciante INT,

    CONSTRAINT fk_anunciante FOREIGN KEY(idAnunciante) REFERENCES Anunciante(idAnunciante)
);
