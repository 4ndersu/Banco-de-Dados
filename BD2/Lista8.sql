CREATE TABLE DEPARTAMENTO
(
    Dnome varchar (15) NOT NULL,
    Dnumero integer PRIMARY KEY,
    Cpf_Gerente varchar(11),
    Data_Inicio_Gerente date
);

CREATE TABLE FUNCIONARIO
(
    Pnome varchar(15) NOT NULL,
    Minicial char,
    Unome varchar(15) NOT NULL,
    CPF varchar(11) PRIMARY KEY,
    Datanasc date,
    Endereço varchar(30),
    Gênero char,
    Salario money,
    CPF_supervisor varchar(11),
    Dnr integer, 
    CONSTRAINT FkeyFUNCIONARIO
	FOREIGN KEY (Dnr)
	REFERENCES DEPARTAMENTO(Dnumero)
);

CREATE TABLE PROJETO(
    Projnome varchar(15) UNIQUE,
    Projnumero integer PRIMARY KEY,
    Projlocal varchar(15),
    Dnum integer NOT NULL,
    CONSTRAINT FkeyProjeto
	FOREIGN KEY (Dnum)
    REFERENCES DEPARTAMENTO (Dnumero)
	);

CREATE TABLE LOCALIZACAO_DEP
(
    Dnumero integer NOT NULL,
    Dlocal varchar(15) COLLATE pg_catalog.default NOT NULL,
    CONSTRAINT PkComposta_LOCALIZACAO_DEP 
	PRIMARY KEY (Dnumero, Dlocal),
    CONSTRAINT Fkey_LOCALIZACAO_DEP
	FOREIGN KEY (Dnumero)
    REFERENCES DEPARTAMENTO (Dnumero) 
	); 

CREATE TABLE TRABALHA_EM (
    Fcpf varchar(11) NOT NULL,
    Pnr integer NOT NULL,
    Horas real,
    CONSTRAINT PkComposta_Trabalha
	PRIMARY KEY (Fcpf, Pnr),
   
	CONSTRAINT Fkey_Trabalha
	FOREIGN KEY (Fcpf)
    REFERENCES FUNCIONARIO (CPF),
  
    CONSTRAINT Fkey2Trabalha
	FOREIGN KEY (Pnr)
    REFERENCES PROJETO (Projnumero) 
	);

CREATE TABLE DEPENDENTE
(
    Fcpf varchar(11) NOT NULL,
    Nome_dependente varchar(15) NOT NULL,
    Gênero char,
    DataNascimento date,
    Parentesco varchar(8),
    CONSTRAINT PkComposta_DEPENDENTE
	PRIMARY KEY (Fcpf, Nome_dependente),
    
	CONSTRAINT Fkey_DEPENDENTE
	FOREIGN KEY (Fcpf)
    REFERENCES FUNCIONARIO (CPF)
	);

INSERT INTO departamento(
	dnome, dnumero, cpf_gerente, data_inicio_gerente)
		VALUES ('Matriz', 1, ' ','1981-06-10'),    
   ('Adminstração', 4, '11111111111','2000-02-15'),
	('Pesquisa', 5, '22222222222','2020-01-20');


INSERT INTO funcionario(
	pnome, minicial, unome, cpf, datanasc, "endereço", "gênero", salario, cpf_supervisor, dnr)
	VALUES ('Jenifer', 'S', 'Souza', '11111111111', '1997-01-14', 'Rua Arthur Lima, 29', 'F', 8500, '9999', 4),
	('Joao', 'B', 'Silva', '12345678900', '1965-01-09', 'Rua Flores, 751', 'M', 30, '22222', 4 ),
	('Jorge', 'E', 'Brito', '22222222222', '1977-10-10', 'Rua do Orto, 129', 'M', 18500, 9999, 1),
	('Fernando', 'T', 'Wong', '4444444444', '1999-09-20', 'Rua da Lapa, 43', 'M', 40.00, 123456, 5),
	('Alice', 'J', 'Zelaya', '99999999999', '1987-09-19', 'Rua Souza Lima, 23', 'F', 35000, 890111, 4),
('Clara', 'A', 'Oliveira', '09142874910', '1980-07-30', 'Rua Agamenon, 54', 'F', 35000, 890111, 1);


INSERT INTO dependente(
	fcpf, nome_dependente, "gênero", datanascimento, parentesco)
	VALUES ('12345678900', 'Janaina', 'F', '1989-03-01', 'Cônjuge'),
	('22222222222', 'Alicia', 'F', '2009-01-01', 'Filha'),
	('99999999999','Tiago', 'M', '2015-03-01', 'Filho' );


INSERT INTO localizacao_dep(
	dnumero, dlocal)
	VALUES (1, 'São Paulo'),
	(4, 'Maua'),
	(4, 'Santo Andre'),
	(5, 'Itu'),
	(5, 'Santo Andre'),
(5, 'Maua');

INSERT INTO projeto(
	projnome, projnumero, projlocal, dnum)
	VALUES ('Produtox', 1, 'Santo Andre', 5),
    ('Produto Y', 2, 'Itu', 5),
    ('Informatização', 10, 'Maua', 4),
    ('Reorganização', 20, 'São Paulo', 1),
    ('Benefício', 30, 'Maua', 5);


INSERT INTO trabalha_em(
	fcpf, pnr, horas)
	VALUES ('11111111111', 1, 32.5),
	('11111111111', 2, 7.5),
	('12345678900', 10, 40),
	('22222222222', 20, 10),
	('99999999999', 30, 8);

--Q1
SELECT pnome, unome FROM FUNCIONARIO
WHERE dnr = (SELECT dnum FROM projeto
            WHERE projnome = 'Informatização'); 

--Q2
SELECT dnome, dnumero FROM DEPARTAMENTO
WHERE cpf_gerente IN (SELECT cpf FROM FUNCIONARIO
            WHERE salario> 10000::money) ; 

--Q3
SELECT pnome, unome FROM FUNCIONARIO
WHERE dnr IN (SELECT dnr FROM FUNCIONARIO
            WHERE pnome = 'Alice') AND Pnome != 'Alice'; 
            
--Q4
SELECT projnome, projnumero FROM PROJETO
WHERE dnum IN (SELECT dNumero FROM LOCALIZACAO_DEP
            WHERE dLocal = 'Maua'); 

--Q5
SELECT pnome, unome FROM FUNCIONARIO
WHERE CPF IN (SELECT cpf_gerente FROM DEPARTAMENTO
            WHERE data_inicio_gerente > '01-01-2000'); 
   
--Q6
SELECT projnome, projnumero FROM PROJETO
WHERE dnum = (SELECT dnr FROM FUNCIONARIO
            WHERE pnome = 'Jorge');
