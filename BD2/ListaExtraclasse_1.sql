--LISTA EXTRACLASSE 1 - BANCO DE DADOS 2
--Minimundo: Centro de Prototipagem Universitário

--Enunciado: O código segue a estrutura da forma que foi ordenada de forma cronologica no enunciado

--Enum para o tipo de usuário que usará o sistema, na questão fala estudante e pesquisador, decidi colocar professor também para ficar completo
CREATE TYPE tipo_usuario AS ENUM ('Estudante', 'Pesquisador', 'Professor');

--Tabela Usuario que fará as reservas 
CREATE TABLE Usuario (
	CPF VARCHAR(11) PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Email VARCHAR(50) NOT NULL UNIQUE,
	--Enum do tipo de usuário
	Tipo tipo_usuario NOT NULL
);

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
	UniveID INT NOT NULL,

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
	--Enum da situação do equipamento, com valor padrão 'Disponivel'
	situacao situacao_equipamento NOT NULL DEFAULT 'Disponivel',
	LabID INT,

	--Constraint para aceitar somente valores positivos de equipamentos
	CONSTRAINT valor_positivo CHECK(Valor > 0),
	--Chave estrangeira simples para um laboratório ter vários equipamentos, mas um equipamento só pode estar alocado em um laboratório
	--Constrain para que ao deletar um laboratório, os equipamentos alocados nele continuem existindo, com LabID NULL
	CONSTRAINT fk_Laboratorio FOREIGN KEY(LabID) REFERENCES Laboratorio(Codigo) ON DELETE SET NULL	
);

--Tabela Reserva que faz a relação entre o usuário e o equipamento
CREATE TABLE Reserva (
	IDReserva INT PRIMARY KEY,
	DataInicio TIMESTAMP NOT NULL,
	DataFim TIMESTAMP NOT NULL,
	--Chave estrangeira do CPF do usuário
	CPFUsuario VARCHAR(11) NOT NULL,
	--Chave estrangeira do Id do equipamento
	IDEquipamento INT,

	--Constraint para aceitar somente datas validas definidas nas regras da questão
	CONSTRAINT datas_validas CHECK(DataFim >= DataInicio),
	--Chaves estrangeiras para o CPF do usuário e o ID do equipamento, com ON DELETE SET NULL em equipamento para manter os registros da reserva mesmo se o equipamento for deletado
	CONSTRAINT fk_CPF FOREIGN KEY (CPFUsuario) REFERENCES Usuario(CPF),
	CONSTRAINT fk_IDEquipamento FOREIGN KEY (IDEquipamento) REFERENCES Equipamento(Codigo) ON DELETE SET NULL
);

----INSERTS----

--Com sucesso
--TABELA UNIVERSIDADE
INSERT INTO Universidade (Codigo, Nome, Endereco, Tipo) VALUES
(1, 'Universidade Federal do Agreste', 'Av. Bom Pastor, s/n - Garanhuns', 'Publica'),
(2, 'Pontifícia Universidade Católica', 'Rua Dom Bosco, 100 - Centro', 'Particular'),
(3, 'Universidade Estadual de Pernambuco', 'Rua Benfica, 455 - Madalena', 'Publica');

--TABELA USUARIO
INSERT INTO Usuario (CPF, Nome, Email, Tipo) VALUES
('11122233344', 'Lucas Andrade', 'lucas.andrade@email.com', 'Estudante'),
('22233344455', 'Dra. Beatriz Santos', 'beatriz.santos@pesquisa.org', 'Pesquisador'),
('33344455566', 'Prof. Carlos Eduardo', 'carlos.eduardo@universidade.edu', 'Professor'),
('44455566677', 'Mariana Costa', 'mariana.costa@estudante.uf.br', 'Estudante'),
('55566677788', 'Dr. Roberto Lima', 'roberto.lima@pesquisa.org', 'Pesquisador');

--TABELA LABORATORIO
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) VALUES
(10, 'Laboratório de Impressão 3D e Prototipagem', 101, 'A', 1),
(11, 'Laboratório de Mecatrônica e Robótica', 102, 'A', 1), --Mesmo bloco A
(20, 'Laboratório de Circuitos Eletrônicos', 201, 'B', 1),
(30, 'Laboratório de Realidade Virtual', 105, 'B', 2), --Mesmo bloco B
(40, 'Laboratório de Sistemas Embarcados', 302, 'C', 3);

---TABELA EQUIPAMENTO
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES
(100, 'Impressora 3D Creality Ender 3', 2499.90, 'Disponivel', 10),
(101, 'Cortadora a Laser CO2 60W', 18500.00, 'Em Uso', 10),
(102, 'Multímetro Digital de Bancada', 1000.00, 'Disponivel', 20),
(103, 'Osciloscópio Digital Agilent 100MHz', 4350.00, 'Disponivel', 20),
(104, 'Kit de Desenvolvimento Arduino Avançado', 320.50, DEFAULT, 11), --Assume 'Disponivel'
(105, 'Braço Robótico Industrial 6 Eixos', 35000.00, 'Manutencao', 11),
(106, 'Scanner 3D de Alta Precisão', 10000.00, 'Disponivel', 10),
(107, 'Óculos de Realidade Virtual Meta Quest 3', 5200.00, 'Disponivel', 30),
(108, 'Estação de Solda Frequência Externa', 890.00, 'Baixado', 20),
(109, 'Impressora 3D Resina Elegoo Mars', 3100.00, DEFAULT, 10);--Assume 'Disponivel' também

--TABELA RESERVA
INSERT INTO Reserva (IDReserva, DataInicio, DataFim, CPFUsuario, IDEquipamento) VALUES
(1, '2026-09-10 08:00:00', '2026-09-10 12:00:00', '11122233344', 100),
(2, '2026-09-11 14:00:00', '2026-09-11 18:00:00', '22233344455', 101),
(3, '2026-09-12 09:00:00', '2026-09-12 11:30:00', '33344455566', 102),
(4, '2026-09-15 10:00:00', '2026-09-15 10:00:00', '44455566677', 103), --Mesmo horário início/fim
(5, '2026-09-20 13:00:00', '2026-09-22 17:00:00', '55566677788', 105);

--Até aqui consegue executar de uma vez no PostGre

--Vão falhar

--TABELA USUÁRIO
--Vai violar o UNIQUE de cliente, colocando um email que já existe
INSERT INTO Usuario (CPF, Nome, Email, Tipo) VALUES 
('99988877766', 'Novo Usuario', 'lucas.andrade@email.com', 'Estudante');--Email duplicado

--Vai Violar o ENUM do tipo de usuário, colocar um tipo que não existe
INSERT INTO Usuario (CPF, Nome, Email, Tipo) VALUES 
('88877766655', 'Pedro Santos', 'pedro@email.com', 'Administrador');--Tipo ADM não definido

--TABELA LABORATORIO
--Vai violar a Constraint Check, colocando um bloco não permitido
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) VALUES 
(50, 'Laboratório de Biologia', 101, 'D', 1);--Bloco D

--Vai violar a Constraint Check colocando uma sala com valor zero ou negativa 
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) VALUES 
(51, 'Laboratório de Química', 0, 'A', 1);--Sala 0

--Vai violar FK colocando um valor que não existe na tabela pai Universidade
INSERT INTO Laboratorio (Codigo, TipoLab, Sala, Bloco, UniveID) VALUES 
(52, 'Laboratório de Física', 102, 'B', 99);--ID 99

--TABELA EQUIPAMENTO
--Vai violar a Constraint Check colocando um valor 0 para um equipamento
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES 
(200, 'Multímetro Digital', 0.00, 'Disponivel', 20);--Valor 0.0

--Também vai violar a Constraint Check, dessa vez colocando um valor negativo
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES 
(201, 'Alicate de Crimpagem', -150.00, 'Disponivel', 20);--Valor -150.0

--Vai violar o ENUM do tipo de equipamento colocando uma situacao que não existe
INSERT INTO Equipamento (Codigo, Nome, Valor, situacao, LabID) VALUES 
(202, 'Fonte de Bancada', 1200.00, 'Quebrado', 20);-- Situacao 'Quebrado'

--TABELA RESERVA
--Vai violar a Constraint Check de data válida colocando uma data de fim menor que a data de inicio
INSERT INTO Reserva (IDReserva, DataInicio, DataFim, CPFUsuario, IDEquipamento) VALUES 
(10, '2026-09-10 12:00:00', '2026-09-06 08:00:00', '11122233344', 100);--Data fim 4 dias menor

--Vai violar a FK colocando um cpf de usuário inexistente
INSERT INTO Reserva (IDReserva, DataInicio, DataFim, CPFUsuario, IDEquipamento) VALUES 
(11, '2026-09-10 08:00:00', '2026-09-10 12:00:00', '00000000000', 100); --CPF 00000000000

--TESTES DE REGISTROS

--Exclusão de Laboratório mantendo o Equipamento
DELETE FROM Laboratorio
SELECT * FROM Equipamento

--Exclusão de um Equipamento mantendo o registro
DELETE FROM Equipamento
SELECT * FROM Reserva

--a)BETWEEN captura os equipamentos que valem exatamente 1000 e 10000
SELECT * FROM Equipamento WHERE Valor BETWEEN 1000.00 AND 10000
ORDER BY Valor DESC

--b)Mesma saída de a), com a diferença que SYMMETRIC vai corrigir o erro de colocar o limite inferior maior que o superior
SELECT * FROM Equipamento WHERE Valor BETWEEN SYMMETRIC 10000.00 AND 1000.00
ORDER BY Valor DESC

--c)Aqui vai mostrar todos os equipamentos que valem menos que 15000 e mais que 20000 por causa da negação de BETWEEN
SELECT * FROM Equipamento WHERE Valor NOT BETWEEN 1500.00 AND 20000.00

--d)Vai pegar a primeira letra(left, 1) do nome do equipamento e mostrar todos os equipamentos com nome entre E e S
SELECT * FROM Equipamento WHERE LEFT(Nome, 1) BETWEEN 'E' AND 'S'