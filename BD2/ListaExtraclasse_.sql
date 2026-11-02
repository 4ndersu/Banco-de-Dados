--Q1
--Tabela referente ao equipamento
CREATE TABLE EQUIPAMENTO(
	idEquipamento VARCHAR(6) PRIMARY KEY,
	nomeEquipamento VARCHAR(100) NOT NULL,
	categoria VARCHAR(50),
	descricao VARCHAR(300) NOT NULL,
	--Constraint checks para o valor do equipamento ser positivo e a data de aquisicao dele ser no máximo até o dia atual
	valor NUMERIC(10,2) NOT NULL CONSTRAINT valor_positivo CHECK(valor > 0.0),
	dataAquisicao DATE NOT NULL CONSTRAINT data_valida CHECK(dataAquisicao <= CURRENT_DATE)
);

--Enumerando tipos de usuarios da universidade
CREATE TYPE tipo AS ENUM ('Aluno', 'Professor', 'Diretor', 'Outro');

--Tabela referente ao responsável do emprestimo
CREATE TABLE RESPONSAVEL(
	CPF VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	--Referencia o tipo de usuario
	tipoResponsavel tipo,
	--Check para data de nascimento ser no maximo igual a atual
	dataNascimento DATE CONSTRAINT dataNasc_valida CHECK(dataNascimento <= CURRENT_DATE)
);

--Tabela refente ao emprestimo
CREATE TABLE EMPRESTIMO (
    idEmprestimo VARCHAR(10) PRIMARY KEY,
    CPF VARCHAR(11) NOT NULL, 
    idEquipamento VARCHAR(6) NOT NULL,
	--Momentos do emprestimo do tipo data/hora
    momentoRetirado TIMESTAMP NOT NULL,
    prevDevolucao TIMESTAMP NOT NULL,
	--Devolucao efetiva pode ser null por enquanto que o equipamento emprestado nao foi devolvido
    efetDevolucao TIMESTAMP NULL,
	--Estado padrao da devolucao é pendente
    status VARCHAR(15) NOT NULL DEFAULT 'Pendente',

	--FKs do cpf do responsavel do equipamento que ele pagou
	--Decidi colocar como FKs normais ao invés de PKs estrangeiras pois permite permite que o histórico de empréstimos seja preservado e que o mesmo usuário possa realizar múltiplos empréstimos do mesmo equipamento em momentos diferentes, o que gera novas tuplas na tabela sem violar restrições de unicidade
    CONSTRAINT fk_cpf FOREIGN KEY (CPF) REFERENCES RESPONSAVEL(CPF),
    CONSTRAINT fk_idE FOREIGN KEY (idEquipamento) REFERENCES EQUIPAMENTO(idEquipamento),

	--Constraint check para o status do emprestimo só atender esses valores
    CONSTRAINT status_valido CHECK (status IN ('Pendente', 'Devolvido', 'Atrasado'))
);

--Q2
--Inserts nas tabelas
-- Inserts na tabela EQUIPAMENTO 
INSERT INTO EQUIPAMENTO (idEquipamento, nomeEquipamento, categoria, descricao, valor, dataAquisicao) VALUES
('EQ001', 'Projetor Epson X49', 'Projetor', 'Projetor multimídia 3300 lumens', 2500.00, '2025-02-10'),
('EQ002', 'Notebook Dell Latitude', 'Notebook', 'Core i5 16GB RAM SSD 512GB', 4500.00, '2025-05-15'),
('EQ003', 'Câmera Canon EOS Rebel', 'Câmera', 'Câmera DSLR com lente 18-55mm', 3200.00, '2024-11-20'),
('EQ004', 'Microfone Shure SM58', 'Microfone', 'Microfone dinâmico com fio', 650.00, '2026-01-12'),
('EQ005', 'Caixa de Som JBL PartyBox', 'Caixa de Som', 'Caixa de som amplificada bluetooth', 1800.00, '2025-08-30'),
('EQ006', 'Mesa de Som Behringer', 'Áudio', 'Mesa de som 12 canais', 2200.00, '2026-03-05');

-- Inserts na tabela RESPONSAVEL
INSERT INTO RESPONSAVEL (CPF, nome, tipoResponsavel, dataNascimento) VALUES
('12345678901', 'Ana Souza', 'Aluno', '2003-04-12'),
('23456789012', 'Carlos Silva', 'Professor', '1982-09-25'),
('34567890123', 'Beatriz Lima', 'Diretor', '1975-12-01'),
('45678901234', 'João Pedro', 'Outro', '1995-07-18'),
('56789012345', 'Mariana Santos', 'Aluno', '2001-11-05'),
('67890123456', 'Roberto Alves', 'Professor', '1978-03-30');

-- Inserts na tabela EMPRESTIMO (12 registros)
INSERT INTO EMPRESTIMO (idEmprestimo, CPF, idEquipamento, momentoRetirado, prevDevolucao, efetDevolucao, status) VALUES
-- Agosto / 2026
('EMP001', '12345678901', 'EQ001', '2026-08-10 08:30:00', '2026-08-15 18:00:00', '2026-08-14 14:15:00', 'Devolvido'),
('EMP002', '45678901234', 'EQ002', '2026-08-18 09:15:00', '2026-08-25 18:00:00', '2026-08-24 11:45:00', 'Devolvido'),

-- Setembro / 2026
('EMP003', '34567890123', 'EQ003', '2026-09-02 10:00:00', '2026-09-09 18:00:00', '2026-09-14 09:30:00', 'Atrasado'),
('EMP004', '12345678901', 'EQ005', '2026-09-12 11:30:00', '2026-09-19 18:00:00', '2026-09-18 16:20:00', 'Devolvido'),
('EMP005', '56789012345', 'EQ005', '2026-09-20 08:30:00', '2026-09-27 17:00:00', '2026-10-02 11:00:00', 'Atrasado'),

-- Outubro / 2026
('EMP006', '23456789012', 'EQ006', '2026-10-05 14:00:00', '2026-10-12 17:00:00', '2026-10-15 10:00:00', 'Atrasado'),
('EMP007', '67890123456', 'EQ004', '2026-10-12 14:30:00', '2026-10-19 18:00:00', '2026-10-18 09:15:00', 'Devolvido'),
('EMP008', '23456789012', 'EQ002', '2026-10-21 09:00:00', '2026-11-05 17:00:00', NULL, 'Pendente'),
('EMP009', '45678901234', 'EQ004', '2026-10-25 13:00:00', '2026-11-02 18:00:00', NULL, 'Pendente'),

-- Novembro / 2026
('EMP010', '56789012345', 'EQ003', '2026-11-01 10:00:00', '2026-11-08 17:00:00', NULL, 'Pendente'),
('EMP011', '34567890123', 'EQ001', '2026-11-03 08:00:00', '2026-11-10 18:00:00', NULL, 'Pendente'),
('EMP012', '67890123456', 'EQ006', '2026-11-05 09:00:00', '2026-11-12 18:00:00', NULL, 'Pendente');

--Q3
--Para mostrar a saída de cada mês por extenso, um case é utilizado para associar um nome de mês ao valor numerico no extract do mes de retirada
SELECT CASE EXTRACT (MONTH from momentoRetirado)
WHEN 1 THEN 'Janeiro'
WHEN 2 THEN 'Fevereiro'
WHEN 3 THEN 'Marco'
WHEN 4 THEN 'Abril'
WHEN 5 THEN 'Maio'
WHEN 6 THEN 'Junho'
WHEN 7 THEN 'Julho'
WHEN 8 THEN 'Agosto'
WHEN 9 THEN 'Setembro'
WHEN 10 THEN 'Outubro'
WHEN 11 THEN 'Novembro'
WHEN 12 THEN 'Dezembro'
END As mes2026, COUNT(*) as qtdEmprestimos FROM Emprestimo --Contador de emprestimos de cada mês
GROUP BY EXTRACT(MONTH from momentoRetirado)--Agrupar resultados de count ao seu respectivo mês de empréstimo
ORDER BY EXTRACT(MONTH from momentoRetirado);--Mostrar meses em ordem crescente por ordenação

--Q4
--Para o relatorio, retorna o id do emprestimo, nome do responsavel e nome do equipamento, uma coluna de tempo previsto para devolucao, outra coluna de tempo efetivo da devolucao e seu status, utilizando as tres tabelas 
SELECT EM.idEmprestimo, R.nome, EQ.nomeEquipamento, AGE(EM.prevDevolucao, EM.momentoRetirado) AS devolucaoInicial, AGE(EM.efetDevolucao, EM.momentoRetirado) AS devolucaoReal, EM.status FROM EMPRESTIMO EM, RESPONSAVEL R, EQUIPAMENTO EQ
--Associacoes para ligar o nome do responsavel com o cpf de RESPONSAVEL e EMPRESTIMO, e nome do equipamento atraves do idEquipamento de EQUIPAMENTO e EMPRESTIMO
WHERE R.CPF = EM.CPF AND EM.idEquipamento = EQ.idEquipamento; 

--Q5
--Função escolhida para analisar sua execução foi a questão 3
EXPLAIN(ANALYZE)
SELECT CASE EXTRACT (MONTH from momentoRetirado)
WHEN 1 THEN 'Janeiro'
WHEN 2 THEN 'Fevereiro'
WHEN 3 THEN 'Marco'
WHEN 4 THEN 'Abril'
WHEN 5 THEN 'Maio'
WHEN 6 THEN 'Junho'
WHEN 7 THEN 'Julho'
WHEN 8 THEN 'Agosto'
WHEN 9 THEN 'Setembro'
WHEN 10 THEN 'Outubro'
WHEN 11 THEN 'Novembro'
WHEN 12 THEN 'Dezembro'
END As mes2026, COUNT(*) as qtdEmprestimos FROM Emprestimo
GROUP BY EXTRACT(MONTH from momentoRetirado)
ORDER BY EXTRACT(MONTH from momentoRetirado); 