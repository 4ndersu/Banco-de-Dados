--Q1
CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Preco DECIMAL,
    Categoria VARCHAR CHECK(Categoria IN('Eletronico', 'Alimento', 'Roupa', 'Livro'))
);

INSERT INTO public.produto(
	codigo, nome, preco, categoria)
	VALUES (13,'Songa' , 6.7, 'Alimento');

--Q2
CREATE TYPE turno AS ENUM('Manha', 'Tarde', 'Noite');

CREATE TABLE Turma (
    Codigo INT PRIMARY KEY,
    Disciplina VARCHAR(100),
    Turno turno NOT NULL
);

INSERT INTO public.turma(
	codigo, disciplina, turno)
	VALUES (3,'Redes' ,'Tarde');

--Q3
CREATE TYPE nivel_acesso AS ENUM('ADM', 'Professor', 'Aluno');

CREATE TABLE Usuario (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    Nivel nivel_acesso NOT NULL
);

INSERT INTO public.Usuario(
	codigo, nome, email, Nivel)
	VALUES (67,'Humberto' ,'@gmail.com', 'ADM');

--Q4
CREATE TABLE Avaliacao (
    Codigo INT PRIMARY KEY,
    Cliente VARCHAR(100),
    Nota INT CHECK(Nota IN(1,2,3,4,5)),
    Classificacao VARCHAR CHECK(Classificacao IN('Ruim', 'Regular', 'Bom', 'Excelente'))
);

INSERT INTO public.avaliacao(
	codigo, cliente, nota, classificacao)
	VALUES (1,'Amanda' , 5, 'Excelente');
    
select * from produto