--ENUMs para definir as regras de negócio e os tipos de dados específicos
CREATE TYPE genero AS ENUM ('Acao', 'Aventura', 'Comedia', 'Drama', 'Ficcao Cientifica', 'Romance', 'Terror');
CREATE TYPE tipoObra AS ENUM ('Filme', 'Serie', 'Documentario', 'Animacao');
CREATE TYPE funcao AS ENUM ('Ator', 'Diretor', 'Roteirista', 'Produtor', 'Fotografo', 'Editor');
CREATE TYPE tipoPlano AS ENUM ('Basico', 'Padrao', 'Premium');
CREATE TYPE qualidadeMax AS ENUM ('720p', '1080p', '4K');
CREATE TYPE maxTelas AS ENUM ('1', '2', '4');
CREATE TYPE exibeAnuncios AS ENUM ('Sim', 'Nao');
CREATE TYPE tipoPerfil AS ENUM ('Adulto', 'Infantil', 'Teen', 'Familia');

---------TABELAS------------
--Observacoes: 
--No cenario Audiovisual, o pais de origem é mais relevante que a cidade ou estado em específico
--Codigos de ID padronizados com 9 caracteres para obras e estúdios, e 11 caracteres para pessoas, usuários e perfis

--Estudio
CREATE TABLE Estudio ( 
    idEstudio VARCHAR(9) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    paisOrigem VARCHAR(45) NOT NULL,
    dataFundacao DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE --Somente um email associado
);

--Obra
CREATE TABLE Obra ( 
    idObra VARCHAR(9) PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    sinopse VARCHAR(300) NOT NULL,
    --Enums definidos acima
    Genero genero NOT NULL,
    TipoObra tipoObra NOT NULL,
    dataLancamento DATE NOT NULL,
    --Check constaint para classificacao indicativa entre 0 e 18 anos, e seu orçamento ser positivo
    classificacaoIndicativa INT NOT NULL CONSTRAINT classificacao_valida CHECK (classificacaoIndicativa BETWEEN 0 AND 18),
    orcamento DECIMAL(10,2) NOT NULL CONSTRAINT orcamento_positivo CHECK (orcamento > 0.0),
    idEstudio VARCHAR(9) NOT NULL,

    --Chave estrangeira para associar obras a somente um estúdio especifico
    CONSTRAINT fk_estudio FOREIGN KEY (idEstudio) REFERENCES Estudio(idEstudio)
);

--Elenco
CREATE TABLE Elenco ( 
    idPessoa VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(30) NOT NULL,
    dataNasc DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE --Email unico para cada pessoa do elenco
);

--Tabela associativa para relacionar várias obras com várias pessoas do elenco
CREATE TABLE Elenco_Obra ( 
    idObra VARCHAR(9),
    idPessoa VARCHAR(11),
    funcao funcao NOT NULL,
    --Check constraints para garantir que o salário e o bônus sejam valores positivos
    salario DECIMAL(10,2) NOT NULL DEFAULT 0.0 CONSTRAINT salario_positivo CHECK (salario >= 0.0),
    bonus DECIMAL(10,2) NOT NULL DEFAULT 0.0 CONSTRAINT bonus_positivo CHECK (bonus >= 0.0),

    --Chave primária composta para garantir a unicidade da combinação de obra e pessoa
    CONSTRAINT pk_composta PRIMARY KEY (idObra, idPessoa),
    
    --Chaves estrangeiras para associar obras e pessoas do elenco
    CONSTRAINT fk_obra FOREIGN KEY (idObra) REFERENCES Obra(idObra),
    CONSTRAINT fk_pessoa FOREIGN KEY (idPessoa) REFERENCES Elenco(idPessoa)
);


--Plano
CREATE TABLE Plano (
    idPlano VARCHAR(9) PRIMARY KEY,
    tipoPlano tipoPlano NOT NULL,
    --Check constraint para garantir que o valor mensal seja positivo
    valorMensal DECIMAL(4,2) NOT NULL CONSTRAINT valor_positivo CHECK (valorMensal > 0.0),
    --Enums definidos acima
    qualidadeMax qualidadeMax NOT NULL,
    maxTelas maxTelas NOT NULL,
    exibeAnuncios exibeAnuncios NOT NULL,

    --Constraint Check para garantir que cada plano associe suas características corretamente
    CONSTRAINT chk_regras_plano CHECK (
        --Basico
        (tipoPlano = 'Basico'  AND qualidadeMax = '720p'  AND maxTelas = '1' AND exibeAnuncios = 'Sim') OR
        --Padrao
        (tipoPlano = 'Padrao'  AND qualidadeMax = '1080p' AND maxTelas = '2' AND exibeAnuncios = 'Nao') OR
        --Premium
        (tipoPlano = 'Premium' AND qualidadeMax = '4K'    AND maxTelas = '4' AND exibeAnuncios = 'Nao')
    )
);

--Usuario
CREATE TABLE Usuario (
    idUsuario VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    --Login pode ser feito tanto por telefone quanto por email
    telefone VARCHAR(15) NOT NULL UNIQUE,--Telefone not null pois é o mais comum de se ter
    email VARCHAR(100) UNIQUE, --Email pode ser nulo, pois nem todos possuem email
    senha VARCHAR(10) NOT NULL,
    idPlano VARCHAR(9),
    
    --Chave estrangeira para associar cada usuário a um plano específico
    CONSTRAINT fk_plano FOREIGN KEY (idPlano) REFERENCES Plano(idPlano)
);

--Perfil
CREATE TABLE Perfil (
    idPerfil VARCHAR(11) PRIMARY KEY,
    nomePerfil VARCHAR(100) NOT NULL,
    --Enum definido acima
    tipoPerfil tipoPerfil NOT NULL,
    idUsuario VARCHAR(11),
    
    --Chave estrangeira para associar um usuario ter vários perfis, mas cada perfil pertence a apenas um usuário
    CONSTRAINT fk_usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

--Anunciante
CREATE TABLE Anunciante (
    idAnunciante VARCHAR(14) PRIMARY KEY,
    nomeEmpresa VARCHAR(100) NOT NULL,
    paisSede VARCHAR(56) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE --Email único
);

--Anuncio
CREATE TABLE Anuncio (
    idAnuncio INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    duracaoSegundos INT NOT NULL,
    videoUrl VARCHAR(100) NOT NULL UNIQUE,
    idAnunciante VARCHAR(14),

    --Chave estrangeira para associar um anunciante a varios anúncios, mas cada anúncio pertence a apenas um anunciante
    CONSTRAINT fk_anunciante FOREIGN KEY (idAnunciante) REFERENCES Anunciante(idAnunciante)
);

--Tabela associativa para relacionar vários anúncios com várias obras, permitindo que um anúncio seja exibido em diferentes obras e em diferentes momentos de exibição
CREATE TABLE Anuncio_Obra (
    idAnuncio INT NOT NULL,
    idObra VARCHAR(9) NOT NULL,
    --Constraint para garantir que o momento de exibição seja um valor positivo e que o número máximo de exibições seja maior que zero
    momentoExibicaoSegundos INT NOT NULL DEFAULT 0 CONSTRAINT momento_positivo CHECK (momentoExibicaoSegundos >= 0),
    maxExibicoes INT NOT NULL DEFAULT 1 CONSTRAINT exibicoes_positivas CHECK (maxExibicoes > 0),

    --Chave primária composta para garantir que varios anúncios possam ser exibidos em diferentes obras
    CONSTRAINT pk_anuncio_obra PRIMARY KEY (idAnuncio, idObra),
    --Chaves estrangeiras para associar anúncios e obras
    CONSTRAINT fk_anuncio_obra_anuncio FOREIGN KEY (idAnuncio) REFERENCES Anuncio(idAnuncio),
    CONSTRAINT fk_anuncio_obra_obra FOREIGN KEY (idObra) REFERENCES Obra(idObra)
);