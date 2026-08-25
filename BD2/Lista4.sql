--CRIAÇÃO DAS TABELAS

CREATE TABLE Curso (
    COD INTEGER PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CH INTEGER NOT NULL
);

CREATE TABLE Aluno (
    Matricula INTEGER PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    AnoEntrada INTEGER NOT NULL,
    Genero VARCHAR(20),
    Email VARCHAR(100),
    CodCurso INTEGER,
    CONSTRAINT fkAluno
        FOREIGN KEY (CodCurso)
        REFERENCES Curso (COD)
);

--Inserção de dados

INSERT INTO Curso (COD, Nome, CH) VALUES 
(1, 'Banco de Dados', 60), 
(2, 'Programação I', 120), 
(3, 'Engenharia de Software', 40), 
(4, 'Redes de Computadores', 40),
 (5, 'Inteligência Artificial', 80),
 (6, 'Análise e desenvolvimento de Software', 100);

INSERT INTO Aluno (Matricula, Nome, AnoEntrada, Genero, Email, CodCurso) VALUES
(1001, 'Maria Silva', 2022, 'Feminino', 'maria.silva@email.com', 1),
(1002, 'João Santos', 2021, 'Masculino', 'joao.santos@email.com', 2),
(1003, 'Ana Clara', 2023, 'Feminino', 'ana.clara@email.com', 1),
(1004, 'Pedro Almeida', 2026, 'Masculino', 'pedro.almeida@email.com', 3),
(1005, 'Mariana Costa', 2022, 'Feminino', 'mariana.costa@email.com', 4),
(1006, 'Carlos Souza', 2021, 'Masculino', 'carlos.souza@email.com', 5),
(1007, 'Amanda Lima', 2023, 'Feminino', 'amanda.lima@email.com', 6),
(1008, 'Lucas Pereira', 2021, 'Masculino', 'lucas.pereira@email.com', 1);



--Q1
Select nome from Aluno
where nome BETWEEN 'A' and 'D'

Select * from Aluno
where left(nome,1) BETWEEN 'A' and 'C'

--Q2
Select * from Aluno
where nome not BETWEEN 'A' and 'D'

Select * from Aluno
where left(nome,1) not BETWEEN 'A' and 'C'

--Q3
Select * from Aluno
where left(nome,2) BETWEEN 'Jo' and 'Ma'

--Q4
Select nome from Aluno
where nome BETWEEN symmetric 'N' and 'A'

Select * from Aluno
where nome not BETWEEN 'A' and 'N'

--Q5
Select * from Aluno
where RIGHT(nome,2) BETWEEN 'da' and 'ma'

--Q6
Select nome, ch from curso
where ch BETWEEN 40 and 80

--Q7
Select * from Aluno
where anoentrada BETWEEN 2021 and 2022

--Q8
Select COUNT(*) from Aluno
where anoentrada BETWEEN 2022 and 2023

--Q9
Select * from curso
where ch not BETWEEN 60 and 80

--Q10
Select * from curso
where ch BETWEEN symmetric 80 and 40
