--TABELAS

--Q1
--Tabela pai Pessoa, com atributos gerais para alunos e professores
CREATE TABLE pessoa (
	CPF VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	--Check para validar a data de nascimento
	dataNasc DATE NOT NULL CONSTRAINT dataNasc_valida CHECK (dataNasc < CURRENT_DATE)
);

--Q1
--Tabela Professor que herda a tabela Pessoa
CREATE TABLE professor (
    idProf VARCHAR(20) PRIMARY KEY,
	areaAtuacao VARCHAR(50) NOT NULL
) INHERITS (pessoa);

--Tabela Curso com fk de um professor para cada curso
CREATE TABLE curso (
	codigo VARCHAR(9) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	--Check para validar a carga horária do curso
	CH INT NOT NULL CONSTRAINT CH_valida CHECK (CH > 0),
	id_professor_coordenador VARCHAR(20) NOT NULL,
	
	--Chave estrangeira para o professor coordenador do curso
	CONSTRAINT fk_curso_professor FOREIGN KEY (id_professor_coordenador) REFERENCES professor(idProf)
);

--Q1
--Tabela Aluno
CREATE TABLE aluno (
	matricula VARCHAR(9) PRIMARY KEY,
	--Check para validar o CR do aluno
	CR DECIMAL(3, 2) NOT NULL DEFAULT 0.0 CONSTRAINT CR_valido CHECK(CR >= 0.0),
	bolsa VARCHAR(20) DEFAULT 'nao tem'--Bolsa pode ser opicional, mas com padrão "nao tem"
) INHERITS (pessoa);

--Tabela Inscricao para relacionar alunos e cursos
CREATE TABLE inscricao (
	nmrInscricao VARCHAR(10) PRIMARY KEY,
	--Unique para garantir que um aluno so possa se inscrever uma vez em um curso especifico
	idAluno VARCHAR(9) NOT NULL UNIQUE,
	idCurso VARCHAR(9) NOT NULL,

	--Chaves estrangeiras para relacionar aluno e curso
	CONSTRAINT fk_aluno_inscricao FOREIGN KEY (idAluno) REFERENCES aluno(matricula),
	CONSTRAINT fk_curso_inscricao FOREIGN KEY (idCurso) REFERENCES curso(codigo)
);


--INSERTS

--Professores
INSERT INTO professor (CPF, nome, email, dataNasc, idProf, areaAtuacao) VALUES 
('66677788899', 'Prof. Roberto Carlos', 'roberto.carlos@email.com', '1980-05-10', 'PROF01', 'Desenvolvimento Web'),
('77788899900', 'Profa. Juliana Lima', 'juliana.lima@email.com', '1985-11-30', 'PROF02', 'Direito Civil'),
('88899900011', 'Prof. Marcos Vinicius', 'marcos.vinicius@email.com', '1975-02-14', 'PROF03', 'Administração Financeira'),
('99900011122', 'Profa. Carla Mendes', 'carla.mendes@email.com', '1990-08-25', 'PROF04', 'Psicologia Organizacional'),
('00011122233', 'Prof. Fernando Rocha', 'fernando.rocha@email.com', '1982-06-05', 'PROF05', 'Design de Interiores');

--Cursos
INSERT INTO curso (codigo, nome, CH, id_professor_coordenador) VALUES 
('SI201', 'Analise e Desenvolviemnto de sistemas', 80, 'PROF01'),
('DIR101', 'Direito', 60, 'PROF02'),
('ADM301', 'Gestão de Negócios', 100, 'PROF03'),
('PSI401', 'Psicologia', 80, 'PROF04'),
('DSG501', 'Design Visual', 60, 'PROF05');

--Alunos
INSERT INTO aluno (CPF, nome, email, dataNasc, matricula, CR, bolsa) VALUES 
('11122233344', 'Ana Silva', 'ana.silva@gmail.com', '2005-03-12', '20261001', 8.5, 'Parcial'),
('22233344455', 'Carlos Souza', 'carlos.souza@hotmail.com', '2004-07-22', '20261002', 9.1, 'Integral'),
('33344455566', 'Mariana Santos', 'mariana.santos@outlook.com', '2006-01-15', '20261003', 7.8, DEFAULT),
('44455566677', 'Lucas Oliveira', 'lucas.oliveira@gmail.com', '2005-09-04', '20261004', 6.5, DEFAULT),
('55566677888', 'Beatriz Lima', 'beatriz.lima@hotmail.com', '2004-12-19', '20261005', 9.5, 'Integral'),
('66677788899', 'Gabriel Costa', 'gabriel.costa@outlook.com', '2005-05-30', '20261006', 7.2, 'Parcial'),
('77788899900', 'Juliana Rocha', 'juliana.rocha@gmail.com', '2003-11-02', '20261007', 8.9, 'Integral'),
('88899900011', 'Matheus Alves', 'matheus.alves@hotmail.com', '2006-02-14', '20261008', 6.9, DEFAULT),
('99900011122', 'Larissa Martins', 'larissa.martins@outlook.com', '2005-08-18', '20261009', 9.0, 'Parcial'),
('10111213141', 'Rafael Barbosa', 'rafael.barbosa@gmail.com', '2004-04-25', '20261010', 7.4, DEFAULT),
('12131415161', 'Camila Ribeiro', 'camila.ribeiro@hotmail.com', '2005-10-10', '20261011', 8.1, 'Integral'),
('13141516171', 'Bruno Araujo', 'bruno.araujo@outlook.com', '2003-06-07', '20261012', 6.2, DEFAULT),
('14151617181', 'Fernanda Dias', 'fernanda.dias@gmail.com', '2006-12-01', '20261013', 9.6, 'Integral'),
('15161718192', 'Thiago Moreira', 'thiago.moreira@hotmail.com', '2005-01-20', '20261014', 7.5, 'Parcial'),
('16171819203', 'Patrícia Gomes', 'patricia.gomes@outlook.com', '2004-09-15', '20261015', 8.8, DEFAULT);

--Inscricoes
INSERT INTO inscricao (nmrInscricao, idAluno, idCurso) VALUES 
('INS01', '20261001', 'ADM301'),
('INS02', '20261012', 'DIR101'),
('INS03', '20261013', 'DSG501'),
('INS04', '20261002', 'ADM301'),
('INS05', '20261014', 'SI201'),
('INS06', '20261006', 'ADM301'),
('INS07', '20261015', 'DSG501'),
('INS08', '20261007', 'ADM301'),
('INS09', '20261008', 'SI201'),
('INS10', '20261004', 'PSI401'),
('INS11', '20261009', 'SI201'),
('INS12', '20261005', 'ADM301'),
('INS13', '20261010', 'SI201'),
('INS14', '20261011', 'DIR101'),
('INS15', '20261003', 'ADM301');

-- 2-a)Selecionar o nome do curso e a quantidade de alunos inscritos em cada curso 
--Utiliza agrupamento e contagem
SELECT C.nome, COUNT(I.idCurso) AS qtdAlunos FROM Curso C, inscricao I
WHERE C.codigo = I.idCurso
GROUP BY C.nome;

-- 2-b)Seleciona o nome dos cursos que possuem mais de 1 aluno inscrito
--nao mostra psicologia porque só tem um aluno
SELECT C.nome FROM Curso C
WHERE (SELECT COUNT(I.idCurso)FROM inscricao I
WHERE I.idCurso = C.codigo) > 1; --Consulta aninhada para contar a quantidade de alunos inscritos em cada curso

-- 2-c)Seleciona nome e curso com maior carga horaria registrada
SELECT C.nome, C.CH  FROM Curso C
WHERE C.CH = (SELECT MAX(CH) FROM Curso); --Consulta aninhada para encontrar maior CH com MAX

-- 2-d)Seleciona a média da carga horaria dos cursos e arredonda para 2 casas decimais
SELECT ROUND(AVG(C.CH)::NUMERIC, 2) AS MediaCH FROM CURSO C;

-- 2-e)Seleciona o nome do curso e a carga horaria dos cursos menores que a média da carga horaria, e utiliza uma concatenacao para criar um anuncio padronizado 
SELECT 'Faça o curso ' || C.nome || ' em apenas ' || C.CH || ' horas!' AS anuncio FROM CURSO C
WHERE (SELECT AVG(CH) FROM CURSO) > C.CH;

-- 2-f)Seleciona o nome do aluno e o dominio do email, e atraves da funcao SUBSTRING extrai cada dominio do email
--Uma consulta diferente para cada dominio diferente

--Utilizando SUBSTRING para extrair o dominio do gmail
--Mostra email completo
SELECT A.nome, A.email AS dominioEmail FROM ALUNO A
WHERE SUBSTRING(A.email FROM 'gmail.com') IS NOT NULL;

--Utilizando STRPOS para extrair o dominio do hotmail
--Mostra o email completo
SELECT A.nome, A.email AS dominioEmail FROM ALUNO A
WHERE STRPOS(A.email, 'hotmail.com') > 0;

--Utilizando SUBSTRING para extrair o dominio do outlook
--Mostra só o dominio do email
SELECT A.nome, SUBSTRING(A.email FROM 'outlook.com') AS dominioEmail FROM ALUNO A
WHERE SUBSTRING(A.email FROM 'outlook.com') IS NOT NULL;