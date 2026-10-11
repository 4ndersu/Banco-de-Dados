CREATE TABLE curso (
	codigo VARCHAR(9) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	CH INT NOT NULL CONSTRAINT CH_valida CHECK (CH > 0)
);

CREATE TABLE pessoa (
	CPF VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	dataNasc DATE NOT NULL
);

CREATE TABLE aluno (
	matricula VARCHAR(9) PRIMARY KEY,
	CR DECIMAL(3, 2) NOT NULL DEFAULT 0.0 CONSTRAINT CR_valido CHECK(CR >= 0.0),
	bolsa VARCHAR(20) DEFAULT 'nao tem'
) INHERITS (pessoa);

CREATE TABLE professor (
    idProf VARCHAR(20) PRIMARY KEY,
	areaAtuacao VARCHAR(50) NOT NULL
) INHERITS (pessoa);

CREATE TABLE inscricao (
	nmrInscricao VARCHAR(10) PRIMARY KEY,
	idAluno VARCHAR(9) NOT NULL UNIQUE,
	idCurso VARCHAR(9) NOT NULL,

	CONSTRAINT fk_aluno_inscricao FOREIGN KEY (idAluno) REFERENCES aluno(matricula),
	CONSTRAINT fk_curso_inscricao FOREIGN KEY (idCurso) REFERENCES curso(codigo)
);

INSERT INTO curso (codigo, nome, CH) VALUES 
('CC101', 'Introdução à Ciência da Computação', 60),
('SI201', 'Banco de Dados I', 80),
('ES301', 'Engenharia de Software', 60),
('RC401', 'Redes de Computadores', 80),
('POO501', 'Programação Orientada a Objetos', 100);

INSERT INTO curso (codigo, nome, CH) VALUES 
('CC102', 'Introdução à Programação', 80);

INSERT INTO professor (CPF, nome, email, dataNasc, idProf, areaAtuacao) VALUES 
('66677788899', 'Prof. Roberto Carlos', 'roberto.carlos@email.com', '1980-05-10', 'PROF01', 'Banco de Dados'),
('77788899900', 'Profa. Juliana Lima', 'juliana.lima@email.com', '1985-11-30', 'PROF02', 'Engenharia de Software'),
('88899900011', 'Prof. Marcos Vinicius', 'marcos.vinicius@email.com', '1975-02-14', 'PROF03', 'Redes de Computadores'),
('99900011122', 'Profa. Carla Mendes', 'carla.mendes@email.com', '1990-08-25', 'PROF04', 'Inteligência Artificial'),
('00011122233', 'Prof. Fernando Rocha', 'fernando.rocha@email.com', '1982-06-05', 'PROF05', 'Algoritmos e Estruturas de Dados');

INSERT INTO aluno (CPF, nome, email, dataNasc, matricula, CR, bolsa) VALUES 
('11122233344', 'Ana Silva', 'ana.silva@email.com', '2005-03-12', '20261001', 8.5, 'Parcial'),
('22233344455', 'Carlos Souza', 'carlos.souza@email.com', '2004-07-22', '20261002', 9.1, 'Integral'),
('33344455566', 'Mariana Santos', 'mariana.santos@email.com', '2006-01-15', '20261003', 7.8, DEFAULT),
('44455566677', 'Lucas Oliveira', 'lucas.oliveira@email.com', '2005-09-04', '20261004', 6.5, DEFAULT),
('55566677888', 'Beatriz Lima', 'beatriz.lima@email.com', '2004-12-19', '20261005', 9.5, 'Integral'),
('66677788899', 'Gabriel Costa', 'gabriel.costa@email.com', '2005-05-30', '20261006', 7.2, 'Parcial'),
('77788899900', 'Juliana Rocha', 'juliana.rocha@email.com', '2003-11-02', '20261007', 8.9, 'Integral'),
('88899900011', 'Matheus Alves', 'matheus.alves@email.com', '2006-02-14', '20261008', 6.9, DEFAULT),
('99900011122', 'Larissa Martins', 'larissa.martins@email.com', '2005-08-18', '20261009', 9.0, 'Parcial'),
('10111213141', 'Rafael Barbosa', 'rafael.barbosa@email.com', '2004-04-25', '20261010', 7.4, DEFAULT),
('12131415161', 'Camila Ribeiro', 'camila.ribeiro@email.com', '2005-10-10', '20261011', 8.1, 'Integral'),
('13141516171', 'Bruno Araujo', 'bruno.araujo@email.com', '2003-06-07', '20261012', 6.2, DEFAULT),
('14151617181', 'Fernanda Dias', 'fernanda.dias@email.com', '2006-12-01', '20261013', 9.6, 'Integral'),
('15161718192', 'Thiago Moreira', 'thiago.moreira@email.com', '2005-01-20', '20261014', 7.5, 'Parcial'),
('16171819203', 'Patrícia Gomes', 'patricia.gomes@email.com', '2004-09-15', '20261015', 8.8, DEFAULT);

INSERT INTO inscricao (nmrInscricao, idAluno, idCurso) VALUES 
('INS01', '20261001', 'CC101'),
('INS02', '20261002', 'SI201'),
('INS03', '20261003', 'ES301'),
('INS04', '20261004', 'RC401'),
('INS05', '20261005', 'POO501'),
('INS06', '20261006', 'CC101'),
('INS07', '20261007', 'SI201'),
('INS08', '20261008', 'ES301'),
('INS09', '20261009', 'RC401'),
('INS10', '20261010', 'POO501'),
('INS11', '20261011', 'CC101'),
('INS12', '20261012', 'SI201'),
('INS13', '20261013', 'ES301'),
('INS14', '20261014', 'RC401'),
('INS15', '20261015', 'POO501');

--a)
SELECT C.nome, COUNT(I.idCurso) AS qtdAlunos FROM Curso C, inscricao i
WHERE C.codigo = I.idCurso
GROUP BY C.nome;

--b)
SELECT C.nome FROM Curso C
WHERE (SELECT COUNT(I.idCurso) FROM inscricao I
WHERE I.idCurso = C.codigo) = 0;

--c)
SELECT C.nome, C.CH  FROM Curso C
WHERE C.CH = (SELECT MAX(C.CH) FROM Curso C);

--d)
SELECT AVG(C.CH) AS MediaCH FROM CURSO C;

--e)
SELECT 'Faça o curso ' || C.nome || '  em apenas ' || C.CH || ' horas!' FROM CURSO C
WHERE (SELECT AVG(C.CH) AS MediaCH FROM CURSO C) > C.CH;

--f) (fazer depois)