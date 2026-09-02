CREATE TYPE TipoUni AS ENUM ('Publica', 'Particular');

CREATE TABLE Universidade (
	Codigo INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Endereco VARCHAR(100) NOT NULL,
	Tipo TipoUni NOT NULL
);

CREATE TABLE Laboratorio (
	Codigo INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Sala INT NOT NULL CHECK(sala > 0),
	Bloco CHAR(1) NOT NULL,
	UniveID INT NOT NULL,

	CONSTRAINT bloco_valido CHECK(Bloco IN('A','B','C')),
	CONSTRAINT fk_Universidade FOREIGN KEY(UniveID) REFERENCES Universidade(Codigo)
);

CREATE TYPE situacao_equipamento AS ENUM('Disponivel', 'Em Uso', 'Manutencao', 'Baixado');

CREATE TABLE Equipamento (
	Codigo INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Valor DECIMAL(10,2) NOT NULL CHECK(Valor > 0),
	situacao situacao_equipamento NOT NULL,
	UniveID INT NOT NULL,

	CONSTRAINT bloco_valido CHECK(Bloco IN('A','B','C')),
	CONSTRAINT fk_Universidade FOREIGN KEY(UniveID) REFERENCES Universidade(Codigo)
);