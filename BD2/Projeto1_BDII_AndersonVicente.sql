-- Criando Tipos Personalizados (ENUMs)
CREATE TYPE genero AS ENUM ('Açao', 'Aventura', 'Comedia', 'Drama', 'Ficcao Cientifica', 'Romance', 'Terror');
CREATE TYPE tipoObra AS ENUM ('Filme', 'Serie', 'Documentario', 'Animacao');
CREATE TYPE funcao AS ENUM ('Ator', 'Diretor', 'Roteirista', 'Produtor', 'Fotografo', 'Editor');
CREATE TYPE tipoPlano AS ENUM ('Basico', 'Padrao', 'Premium');
CREATE TYPE qualidadeMax AS ENUM ('720p', '1080p', '4K');
CREATE TYPE maxTelas AS ENUM ('1', '2', '4');
CREATE TYPE exibeAnuncios AS ENUM ('Sim', 'Nao');
CREATE TYPE tipoPerfil AS ENUM ('Adulto', 'Infantil', 'Teen', 'Familia');

-- Criando as Tabelas
CREATE TABLE Estudio ( 
    idEstudio VARCHAR(9) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    paisOrigem VARCHAR(45) NOT NULL,
    dataFundacao DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Obra ( 
    idObra VARCHAR(9) PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    sinopse VARCHAR(300) NOT NULL,
    Genero genero NOT NULL,
    TipoObra tipoObra NOT NULL,
    dataLancamento DATE NOT NULL,
    classificacaoIndicativa INT NOT NULL CONSTRAINT classificacao_valida CHECK (classificacaoIndicativa BETWEEN 0 AND 18),
    orcamento DECIMAL(10,2) NOT NULL CONSTRAINT orcamento_positivo CHECK (orcamento > 0.0),
    idEstudio VARCHAR(9) NOT NULL,

    CONSTRAINT fk_estudio FOREIGN KEY (idEstudio) REFERENCES Estudio(idEstudio)
);

CREATE TABLE Elenco ( 
    idPessoa VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(30) NOT NULL,
    dataNasc DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Elenco_Obra ( 
    idObra VARCHAR(9),
    idPessoa VARCHAR(11),
    Funcao funcao NOT NULL,
    salario DECIMAL(10,2) NOT NULL DEFAULT 0.0 CONSTRAINT salario_positivo CHECK (salario >= 0.0),
    bonus DECIMAL(10,2) NOT NULL DEFAULT 0.0 CONSTRAINT bonus_positivo CHECK (bonus >= 0.0),

    CONSTRAINT pk_composta PRIMARY KEY (idObra, idPessoa, Funcao),
    CONSTRAINT fk_obra FOREIGN KEY (idObra) REFERENCES Obra(idObra),
    CONSTRAINT fk_pessoa FOREIGN KEY (idPessoa) REFERENCES Elenco(idPessoa)
);

CREATE TABLE Plano (
    idPlano VARCHAR(9) PRIMARY KEY,
    tipoPlano tipoPlano NOT NULL,
    valorMensal DECIMAL(4,2) NOT NULL,
    qualidadeMax qualidadeMax NOT NULL,
    maxTelas maxTelas NOT NULL,
    exibeAnuncios exibeAnuncios NOT NULL,

    CONSTRAINT chk_regras_plano CHECK (
        (tipoPlano = 'Basico'  AND valorMensal = 9.99  AND qualidadeMax = '720p'  AND maxTelas = '1' AND exibeAnuncios = 'Sim') OR
        (tipoPlano = 'Padrao'  AND valorMensal = 19.99 AND qualidadeMax = '1080p' AND maxTelas = '2' AND exibeAnuncios = 'Nao') OR
        (tipoPlano = 'Premium' AND valorMensal = 29.99 AND qualidadeMax = '4K'    AND maxTelas = '4' AND exibeAnuncios = 'Nao')
    )
);

CREATE TABLE Usuario (
    idUsuario VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(10) NOT NULL,
    idPlano VARCHAR(9),
    
    CONSTRAINT fk_plano FOREIGN KEY (idPlano) REFERENCES Plano(idPlano)
);

CREATE TABLE Perfil (
    idPerfil VARCHAR(2) PRIMARY KEY,
    nomePerfil VARCHAR(100) NOT NULL,
    tipoPerfil tipoPerfil NOT NULL,
    idUsuario VARCHAR(11),
    
    CONSTRAINT fk_usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Anunciante (
    CNPJ VARCHAR(14) PRIMARY KEY,
    nomeEmpresa VARCHAR(100) NOT NULL,
    paisSede VARCHAR(56) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Anuncio (
    idAnuncio INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    duracaoSegundos INT NOT NULL,
    videoUrl VARCHAR(100) NOT NULL UNIQUE,
    CNPJ VARCHAR(14),

    CONSTRAINT fk_anunciante FOREIGN KEY (CNPJ) REFERENCES Anunciante(CNPJ)
);