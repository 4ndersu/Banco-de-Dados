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
    orcamento DECIMAL(15,2) NOT NULL CONSTRAINT orcamento_positivo CHECK (orcamento > 0.0),
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
    salario DECIMAL(15,2) NOT NULL DEFAULT 0.0 CONSTRAINT salario_positivo CHECK (salario >= 0.0),
    bonus DECIMAL(15,2) NOT NULL DEFAULT 0.0 CONSTRAINT bonus_positivo CHECK (bonus >= 0.0),

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

------INSERTS DAS TABELAS--------

-----------Tabela Estudio (8 registros)------------
INSERT INTO Estudio (idEstudio, nome, paisOrigem, dataFundacao, email) VALUES
('EST000001', 'Warner Bros. Pictures', 'Estados Unidos', '1923-04-04', 'contact@warnerbros.com'),
('EST000002', 'Universal Pictures', 'Estados Unidos', '1912-04-30', 'info@universalpictures.com'),
('EST000003', 'O2 Filmes', 'Brasil', '1991-01-15', 'contato@o2filmes.com.br'),
('EST000004', 'Toho Co., Ltd.', 'Japao', '1932-08-12', 'international@toho.co.jp'),
('EST000005', 'A24 Films', 'Estados Unidos', '2012-08-20', 'info@a24films.com'),
('EST000006', 'Gullane Entretenimento', 'Brasil', '1996-05-10', 'gullane@gullane.com.br'),
('EST000007', 'Studio Ghibli', 'Japao', '1985-06-15', 'contact@ghibli.jp'),
('EST000008', 'BBC Studios', 'Reino Unido', '1957-04-01', 'info@bbcstudios.com');

-----------Tabela Obra(11 registros)------------
INSERT INTO Obra (idObra, titulo, sinopse, Genero, TipoObra, dataLancamento, classificacaoIndicativa, orcamento, idEstudio) VALUES
('OBR000001', 'Inception', 'Um ladrão que rouba segredos corporativos através do uso da tecnologia de compartilhamento de sonhos.', 'Ficcao Cientifica', 'Filme', '2010-07-16', 14, 160000000.00, 'EST000001'),
('OBR000002', 'Oppenheimer', 'A história do físico americano J. Robert Oppenheimer e seu papel no Projeto Manhattan na Segunda Guerra Mundial.', 'Drama', 'Filme', '2023-07-20', 16, 100000000.00, 'EST000002'),
('OBR000003', 'Cidade de Deus', 'Dois meninos crescendo em um bairro violento do Rio de Janeiro encontram caminhos diferentes na vida.', 'Drama', 'Filme', '2002-08-30', 18, 3300000.00, 'EST000003'),
('OBR000004', 'A Viagem de Chihiro', 'Uma menina de 10 anos vagueia por um mundo governado por deuses, bruxas e espíritos.', 'Aventura', 'Animacao', '2001-07-20', 0, 19000000.00, 'EST000007'),
('OBR000005', 'Marty Supreme', 'Cinebiografia ficcional baseada na vida do jogador profissional de pingue-pongue Marty Reisman.', 'Comedia', 'Filme', '2025-12-25', 14, 70000000.00, 'EST000005'),
('OBR000006', 'Sintonia', 'Três amigos da favela buscam seus sonhos no funk, no tráfico e na religião.', 'Drama', 'Serie', '2019-08-09', 16, 8000000.00, 'EST000006'),
('OBR000007', 'Planet Earth II', 'Série documental sobre a vida selvagem e os habitats naturais do planeta Terra.', 'Aventura', 'Documentario', '2016-11-06', 0, 10000000.00, 'EST000008'),
('OBR000008', 'Godzilla Minus One', 'O Japão pós-guerra precisa enfrentar uma nova e terrível ameaça gigante.', 'Acao', 'Filme', '2023-11-03', 12, 15000000.00, 'EST000004'),
('OBR000009', 'Hereditary', 'Após a morte da avó reclusa, a família Graham começa a desvendar segredos sombrios e aterrorizantes.', 'Terror', 'Filme', '2018-06-08', 16, 10000000.00, 'EST000005'),
('OBR000010', 'La La Land', 'Um pianista de jazz e uma aspirante a atriz se apaixonam enquanto buscam seus sonhos em Los Angeles.', 'Romance', 'Filme', '2016-12-09', 12, 30000000.00, 'EST000002'),
('OBR000011', 'The Witcher', 'O caçador de monstros Geralt de Rivia luta para encontrar seu lugar em um mundo onde as pessoas são mais perversas que as feras.', 'Aventura', 'Serie', '2019-12-20', 18, 92000000.00, 'EST000001');

------------Tabela Elenco (10 registros)------------
INSERT INTO Elenco (idPessoa, nome, nacionalidade, dataNasc, email) VALUES
('PES00000001', 'Leonardo DiCaprio', 'Norte-Americano', '1974-11-11', 'leonardo@actor.com'),
('PES00000002', 'Christopher Nolan', 'Britanico', '1970-07-30', 'nolan@director.com'),
('PES00000003', 'Cillian Murphy', 'Irlandes', '1976-05-25', 'cillian@actor.com'),
('PES00000004', 'Alexandre Rodrigues', 'Brasileiro', '1983-05-21', 'alexandre@ator.com.br'),
('PES00000005', 'Fernando Meirelles', 'Brasileiro', '1955-11-09', 'meirelles@o2filmes.com.br'),
('PES00000006', 'Alex Honnold', 'Norte-Americano', '1985-08-17', 'alex@honnold.com'),
('PES00000007', 'Hayao Miyazaki', 'Japao', '1941-01-05', 'miyazaki@ghibli.jp'),
('PES00000008', 'David Attenborough', 'Britanico', '1926-05-08', 'david@attenborough.org'),
('PES00000009', 'Timothée Chalamet', 'Franco-Americano', '1995-12-27', 'timothee@chalamet.com'),
('PES00000010', 'Roger Deakins', 'Britanico', '1949-05-24', 'deakins@cinematography.com'),
('PES00000011', 'Lee Smith', 'Australiano', '1960-05-08', 'lee.smith@editor.com'),
('PES00000012', 'Linus Sandgren', 'Sueco', '1972-12-03', 'linus@sandgren.com');

-----------Tabela Elenco_Obra (13 registros)------------
INSERT INTO Elenco_Obra (idObra, idPessoa, Funcao, salario, bonus) VALUES
----Obra com mais de uma pessoa do elenco
('OBR000001', 'PES00000001', 'Ator', 15000000.00, 2000000.00),
('OBR000001', 'PES00000002', 'Diretor', 20000000.00, 5000000.00),
('OBR000001', 'PES00000011', 'Editor', 1200000.00, 150000.00),
----Pessoa com mais de uma obra
('OBR000001', 'PES00000003', 'Ator', 8000000.00, 500000.00), --Cillian Murphy trabalhou também em Inception
('OBR000002', 'PES00000003', 'Ator', 10000000.00, 1000000.00),
----Demais registros
('OBR000002', 'PES00000002', 'Roteirista', 12000000.00, 2000000.00),
('OBR000003', 'PES00000005', 'Diretor', 500000.00, 50000.00),
('OBR000004', 'PES00000007', 'Roteirista', 2500000.00, 400000.00),
('OBR000005', 'PES00000009', 'Ator', 1800000.00, 300000.00),
('OBR000007', 'PES00000008', 'Ator', 1200000.00, 200000.00),
('OBR000009', 'PES00000006', 'Produtor', 1800000.00, 300000.00),
('OBR000010', 'PES00000012', 'Fotografo', 2500000.00, 200000.00),
('OBR000011', 'PES00000010', 'Fotografo', 3000000.00, 400000.00);

-----------Tabela Plano (3 registros por só existir 3 planos)------------
INSERT INTO Plano (idPlano, tipoPlano, valorMensal, qualidadeMax, maxTelas, exibeAnuncios) VALUES
('PLN000001', 'Basico', 9.99, '720p', '1', 'Sim'),
('PLN000002', 'Padrao', 19.99, '1080p', '2', 'Nao'),
('PLN000003', 'Premium', 29.99, '4K', '4', 'Nao');

-----------Tabela Usuario (8 registros)------------
INSERT INTO Usuario (idUsuario, nome, telefone, email, senha, idPlano) VALUES
('USR00000001', 'Carlos Silva', '11987654321', 'carlos.silva@email.com', 'Senha123', 'PLN000001'),
('USR00000002', 'Mariana Santos', '21976543210', 'mariana.santos@email.com', 'Pass321', 'PLN000002'),
('USR00000003', 'Roberto Rocha', '31965432109', 'roberto.rocha@email.com', 'Rob@2024', 'PLN000003'),
('USR00000004', 'Fernanda Lima', '41954321098', 'fernanda.lima@email.com', 'Fer#8899', 'PLN000001'),
('USR00000005', 'Lucas Oliveira', '51943210987', 'lucas.oliveira@email.com', 'Luc12345', 'PLN000002'),
('USR00000006', 'Patricia Souza', '61932109876', 'patricia.souza@email.com', 'PatS2024', 'PLN000003'),
('USR00000007', 'Gabriel Costa', '71921098765', 'gabriel.costa@email.com', 'Gabe9988', 'PLN000001'),
('USR00000008', 'Beatriz Alves', '81910987654', 'beatriz.alves@email.com', 'BiaPass77', 'PLN000002');

-----------Tabela Perfil (8 registros)------------
INSERT INTO Perfil (idPerfil, nomePerfil, tipoPerfil, idUsuario) VALUES
---Perfis diferentes para cada usuário
('P1', 'Carlos', 'Adulto', 'USR00000001'),
('P2', 'Carlinhos', 'Infantil', 'USR00000001'),
('P3', 'Mariana', 'Adulto', 'USR00000002'),
('P4', 'Familia Santos', 'Familia', 'USR00000002'),
--Demais perfis
('P5', 'Beto', 'Teen', 'USR00000003'),
('P6', 'Paty', 'Adulto', 'USR00000006'),
('P7', 'Gabi', 'Teen', 'USR00000007'),
('P8', 'BiaKids', 'Infantil', 'USR00000008');

-----------Tabela Anunciante (8 registros)------------
INSERT INTO Anunciante (idAnunciante, nomeEmpresa, paisSede, email) VALUES
('12345678000195', 'Coca-Cola Brasil', 'Brasil', 'mkt@cocacola.com.br'),
('98765432000110', 'Samsung Electronics', 'Coreia do Sul', 'ad@samsung.com'),
('45678912000133', 'Nike do Brasil', 'Estados Unidos', 'comercial@nike.com.br'),
('11223344000155', 'Ambev S.A.', 'Brasil', 'contato@ambev.com.br'),
('66778899000122', 'Amazon Services', 'Estados Unidos', 'ads@amazon.com'),
('33445566000188', 'Banco Itaú', 'Brasil', 'marketing@itau.com.br'),
('55667788000144', 'Sony Electronics', 'Japao', 'ads@sony.com'),
('77889900000166', 'Natura Cosméticos', 'Brasil', 'contato@natura.com.br');

-----------Tabela Anuncio (8 registros)------------
INSERT INTO Anuncio (idAnuncio, titulo, duracaoSegundos, videoUrl, idAnunciante) VALUES
(101, 'Abra a Felicidade - Verao', 30, 'https://cdn.ads.com/cocacola_verao.mp4', '12345678000195'),
(102, 'Novo Galaxy S24 Ultra', 15, 'https://cdn.ads.com/samsung_s24.mp4', '98765432000110'),
(103, 'Just Do It - Corra Mais', 30, 'https://cdn.ads.com/nike_run.mp4', '45678912000133'),
(104, 'Guaraná Antarctica 0', 15, 'https://cdn.ads.com/guarana_zero.mp4', '11223344000155'),
(105, 'AWS Cloud Solutions', 45, 'https://cdn.ads.com/aws_cloud.mp4', '66778899000122'),
(106, 'Feito de Futuro - Itaú', 30, 'https://cdn.ads.com/itau_futuro.mp4', '33445566000188'),
(107, 'PlayStation 5 Slim', 20, 'https://cdn.ads.com/sony_ps5.mp4', '55667788000144'),
(108, 'Bem Estar Bem - Natura', 30, 'https://cdn.ads.com/natura_viver.mp4', '77889900000166');

-----------Tabela Anuncio_Obra (8 registros)------------
INSERT INTO Anuncio_Obra (idAnuncio, idObra, momentoExibicaoSegundos, maxExibicoes) VALUES
(101, 'OBR000001', 0, 5000),
(102, 'OBR000001', 1800, 2000),
(103, 'OBR000003', 0, 10000),
(104, 'OBR000003', 3600, 8000),
(105, 'OBR000005', 0, 3000),
(106, 'OBR000006', 600, 15000),
(107, 'OBR000008', 0, 4000),
(108, 'OBR000006', 1200, 7000);

-------Inserts que não irão funcionar por conta das constraints definidas, para testar sua validade--------------
--(A partir daqui não roda se o script completo)

-----Obra com classificação indicativa maior que 18 anos-------
INSERT INTO Obra (idObra, titulo, sinopse, Genero, TipoObra, dataLancamento, classificacaoIndicativa, orcamento, idEstudio) VALUES 
('OBR000099', 'O Exorcista', 'Quando uma adolescente é possuída por uma entidade misteriosa, sua mãe busca a ajuda de dois padres católicos para salvar sua vida.', 'Terror', 'Filme', '1973-12-26', 21, 5000000.00, 'EST000001');

-----Obra com orçamento negativo-------
INSERT INTO Obra (idObra, titulo, sinopse, Genero, TipoObra, dataLancamento, classificacaoIndicativa, orcamento, idEstudio) VALUES 
('OBR000098', 'Halloween: A Noite do Terror', 'Um serial killer assombra a cidade de Haddonfield durante a noite de Halloween.', 'Terror', 'Filme', '1978-10-26', 14, -1000000.00, 'EST000002');

-----Pessoa do elenco com salario e bonus negativos-------
INSERT INTO Elenco_Obra (idObra, idPessoa, funcao, salario, bonus) VALUES 
('OBR000001', 'PES00000001', 'Ator', -1500.00, 0.00),
('OBR000002', 'PES00000001', 'Diretor', 50000.00, -500.00);

-----Plano com inconsistencia entre seu tipo e suas caracteristicas-------
INSERT INTO Plano (idPlano, tipoPlano, valorMensal, qualidadeMax, maxTelas, exibeAnuncios) VALUES 
('PLN000099', 'Basico', 9.99, '1080p', '1', 'Sim');

----Plano com valor mensal nulo ou negativo-------
INSERT INTO Plano (idPlano, tipoPlano, valorMensal, qualidadeMax, maxTelas, exibeAnuncios) VALUES 
('PLN000098', 'Basico', 0.00, '720p', '1', 'Sim');

----Momento negativo e maxExibicoes zerado de um anuncio em uma obra-------
INSERT INTO Anuncio_Obra (idAnuncio, idObra, momentoExibicaoSegundos, maxExibicoes) VALUES  
(101, 'OBR000001', -30, 5000),
(102, 'OBR000001', 0, 0);

-----Perfil com tipo que não existe-------
INSERT INTO Perfil (idPerfil, nomePerfil, tipoPerfil, idUsuario) VALUES 
('P9', 'Perfil Pet', 'Gatos', 'USR00000001');

---Consulta 1: pesquisar obras do gênero Drama, ordenadas pela data de lançamento mais recente
SELECT titulo, sinopse, genero, tipoObra, datalancamento, classificacaoindicativa FROM OBRA 
WHERE genero IN ('Drama') ORDER BY datalancamento DESC;

---Consulta 2: pesquisar obras de acordo com a palavra chave de seu titulo ou sinopse
--Exemplo 1: palavra "vida"
SELECT titulo, sinopse, genero, tipoObra, datalancamento, classificacaoindicativa FROM OBRA 
WHERE titulo ILIKE '%vida%' OR sinopse ILIKE '%vida%';

--Exemplo 2: palavra "morte"
SELECT titulo, sinopse, genero, tipoObra, datalancamento, classificacaoindicativa FROM OBRA 
WHERE titulo ILIKE '%morte%' OR sinopse ILIKE '%morte%';

--Exemplo 3: palavra "guerra"
SELECT titulo, sinopse, genero, tipoObra, datalancamento, classificacaoindicativa FROM OBRA 
WHERE titulo ILIKE '%guerra%' OR sinopse ILIKE '%guerra%';

---Consulta 3: pesquisar obras lançadas entre os anos 2000 e 2020
SELECT titulo, sinopse, genero, tipoObra, datalancamento, classificacaoindicativa FROM OBRA 
WHERE datalancamento BETWEEN '2000-01-01' AND '2020-12-31' ORDER BY datalancamento ASC;

--Consulta 4: contar e listar quantas obras foram produzidas por um determinado estúdio.
SELECT COUNT(*) from OBRA
WHERE idEstudio LIKE 'EST000005';

SELECT titulo, sinopse FROM obra
WHERE idEstudio = 'EST000005';

--Consulta 5: listar pessoas do elenco que trabalharam em determinada obra
SELECT idPessoa, funcao FROM elenco_obra
WHERE idObra LIKE 'OBR000001' AND funcao IN ('Ator');

SELECT idObra FROM elenco_obra
WHERE idPessoa LIKE 'PES00000003';

SELECT titulo, sinopse FROM obra
WHERE idObra LIKE 'OBR000002';
