--Tipo Enum para o tipo de universidade do minimundo
CREATE TYPE TipoUni AS ENUM ('Publica', 'Particular');

--Tabela Universidade onde o laboratório está alocado
CREATE TABLE Universidade (
	Codigo INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Endereco VARCHAR(100) NOT NULL,
	--Enum do tipo de universidade
	Tipo TipoUni NOT NULL

);

--Tabela Laboratorio onde os equipamentos estão alocados
CREATE TABLE Laboratorio (
	Codigo INT PRIMARY KEY,
	TipoLab VARCHAR(100) NOT NULL,
	Sala INT NOT NULL,
	Bloco CHAR(1) NOT NULL,
	--Chave estrangeira para a tabela Universidade
	UniveID INT,

	--Constraint para aceitar somente salas válidas, visto que não existem salas negativas ou 0
	CONSTRAINT sala_Valida CHECK(Sala > 0),
	--Constraint para aceitar somente os blocos válidos da questão
	CONSTRAINT bloco_valido CHECK(Bloco IN('A','B','C')),
	--Definição da chave estrangeira para o ID da Universidade
	--Chave estrangeira simples para uma universidade ter vários laboratórios, mas um laboratório só pode estar alocado em uma universidade
	CONSTRAINT fk_Universidade FOREIGN KEY(UniveID) REFERENCES Universidade(Codigo)
);

--Enum para a situação do equipamento
CREATE TYPE situacao_equipamento AS ENUM('Disponivel', 'Em Uso', 'Manutencao', 'Baixado');

--Tabela Equipamento pertencente a um laboratório
CREATE TABLE Equipamento (
	Codigo INT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Valor DECIMAL(10,2) NOT NULL,
	--Enum da situação do equipamento
	situacao situacao_equipamento NOT NULL DEFAULT 'Disponivel',
	LabID INT ,

	--Constraint para aceitar somente valores positivos de equipamentos
	CONSTRAINT valor_positivo CHECK(Valor > 0),
	--Chave estrangeira simples para um laboratório ter vários equipamentos, mas um equipamento só pode estar alocado em um laboratório
	CONSTRAINT fk_Laboratorio FOREIGN KEY(LabID) REFERENCES Laboratorio(Codigo) ON DELETE SET NULL
	--Constrain para que ao deletar um laboratório, os equipamentos alocados nele continuem existindo, com LabID NULL
	
);

CREATE TABLE Usuario (
	CPF VARCHAR(11) PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Email VARCHAR(50) NOT NULL
);

CREATE TABLE Reserva (
	IDReserva INT PRIMARY KEY,
	DataInicio DATE,
	DataFim DATE,
	CPFUsuario VARCHAR(11) NOT NULL,
	IDEquipamento INT NOT NULL,

	CONSTRAINT datas_validas CHECK(DataFim > DataInicio)
);

INSERT INTO Universidade (Codigo, Nome, Endereco, Tipo) VALUES
(1, 'Universidade Federal', 'Av. Acadêmica, 100', 'Publica'),
(2, 'Pontifícia Universidade', 'Rua Central, 500', 'Particular');

-- Inserções válidas (Blocos A, B ou C e Sala > 0)
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) VALUES
(10, 'Laboratório de Robótica', 101, 'A', 1),
(20, 'Laboratório de Impressão 3D', 102, 'B', 1),
(30, 'Laboratório de Eletrônica', 201, 'C', 2);

-- Tenta inserir Bloco 'D' (Viola a restrição bloco_valido)
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) 
VALUES (40, 'Laboratório Invalido', 101, 'D', 1);

-- Tenta inserir Sala <= 0 (Viola a restrição sala_Valida)
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) 
VALUES (50, 'Laboratório Invalido', -5, 'A', 1);

-- 1. Equipamento normal especificando todos os campos
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES
(100, 'Impressora 3D Ender 3', 2500.00, 'Disponivel', 20),
(101, 'Osciloscópio Digital', 4200.50, 'Em Uso', 30);

-- 2. Equipamento sem informar 'situacao' (Deve assumir DEFAULT 'Disponivel')
INSERT INTO Equipamento (Codigo, Nome, Valor, LabID) VALUES
(102, 'Kit Arduino Avançado', 350.00, 10);

-- 3. Equipamento com outra situação do Enum
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES
(103, 'Braço Robótico Industrial', 15000.00, 'Manutencao', 10);

-- Tenta inserir Valor <= 0 (Viola a restrição valor_positivo)
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) 
VALUES (104, 'Multímetro Invalido', 0.00, 'Disponivel', 30);

-- Tenta inserir uma situação inexistente no ENUM (Viola o tipo situacao_equipamento)
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) 
VALUES (105, 'Torno CNC', 8000.00, 'Quebrado', 20);

SELECT * FROM Universidade
SELECT * FROM Laboratorio
SELECT * FROM Equipamento

DELETE FROM laboratorio
