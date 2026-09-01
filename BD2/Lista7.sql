--Q1
CREATE TABLE MaterialBiblioteca (
    Codigo INT PRIMARY KEY,
    Titulo VARCHAR(120) NOT NULL,
    AnoPublicacao INT
);

CREATE TABLE LivroRaro(
    NumeroRegistro VARCHAR(20) PRIMARY KEY,
    ValorEstimado NUMERIC(10,2)
) INHERITS(MaterialBiblioteca);

--a)
INSERT INTO public.materialbiblioteca(
	codigo, titulo, anopublicacao)
	VALUES (13, 'Diario de Annie Frank', 1980);

INSERT INTO public.materialbiblioteca(
	codigo, titulo, anopublicacao)
	VALUES (22, 'Livro das Snções', 2017);

--b)
INSERT INTO public.livroraro(
	codigo, titulo, anopublicacao, numeroregistro, valorestimado)
	VALUES (67, 'A volta dos q n foram', 1967, 123, 233.2);
    
INSERT INTO public.livroraro(
	codigo, titulo, anopublicacao, numeroregistro, valorestimado)
	VALUES (98, 'Songa a Biografia', 2026, 321, 99.5);
    
--c)
Select * from MaterialBiblioteca
Select * from livroraro

--d)
Select * from only MaterialBiblioteca

--e)
--Enquanto a consulta da tabela pai sem o only vai buscar as instancias inseridas em todas as suas referencias nas tabelas filhas
--E com only se limita somente na tabela pai

--Q2
CREATE TABLE Evento (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    QuantidadeVagas INT CHECK (QuantidadeVagas > 0)
);

CREATE TABLE Congresso(
    Sigla VARCHAR(20) PRIMARY KEY,
    AreaTematica VARCHAR(80)
) INHERITS(Evento);

--a)
INSERT INTO public.congresso(
	codigo, nome, quantidadevagas, sigla, areatematica)
	VALUES (98, NULL, 13, 'AU', 'escola');

--b)
INSERT INTO public.congresso(
	codigo, nome, quantidadevagas, sigla, areatematica)
	VALUES (98, 'Ana', 0, 'AU', 'escola');

--c)
INSERT INTO public.congresso(
	codigo, nome, quantidadevagas, sigla, areatematica)
	VALUES (17, 'Songa', 12, 'BC', 'escola');

INSERT INTO public.congresso(
	codigo, nome, quantidadevagas, sigla, areatematica)
	VALUES (22, 'Ego', 10, 'BC', 'casa');

--d)
INSERT INTO public.evento(
	codigo, nome, quantidadevagas)
	VALUES (98, 'Ana', 98);
