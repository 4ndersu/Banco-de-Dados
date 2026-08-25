--Q1
CREATE TABLE Cliente(
    Cod INTEGER PRIMARY KEY,
    Nome VARCHAR(100),
    Idade INTEGER CONSTRAINT idade_valida CHECK(idade BETWEEN 18 AND 100)
);

--Q2
CREATE TABLE Aluno2(
    Matricula INTEGER PRIMARY KEY,
    Nome VARCHAR(100),
    Nota DECIMAL(3,2) CONSTRAINT nota_valida CHECK(Nota BETWEEN 0 AND 10),
    Frequencia INTEGER CONSTRAINT frquencia_valida CHECK(Frequencia BETWEEN 0 AND 100)
);

--Q3
CREATE TABLE Veiculo(
    Placa INTEGER PRIMARY KEY,
    Modelo VARCHAR(100),
    Ano INTEGER CONSTRAINT ano_valido CHECK(Ano >= 200),
    QtdPortas INTEGER CONSTRAINT qtd_valida CHECK(QtdPortas BETWEEN 2 AND 5)
);

--Q4
CREATE TABLE Reserva(
    Codigo INTEGER PRIMARY KEY,
    NomeResponsavel VARCHAR(100),
    QtdPessoas INTEGER CONSTRAINT Pessoas_valido CHECK(QtdPessoas BETWEEN 1 AND 20),
    ValorReserva DECIMAL(6,2) CONSTRAINT Valor_valido CHECK(ValorReserva >= 0)
);

--Q5
CREATE TABLE Funcionario(
    Codigo INTEGER PRIMARY KEY,
    Nome VARCHAR(100),
    Salario DECIMAL(6,2) CONSTRAINT Salario_valido CHECK(Salario >= 0),
    CH INTEGER CONSTRAINT Ch_valido CHECK(CH BETWEEN 20 AND 44),
    Situacao VARCHAR(100) NOT NULL,
    CONSTRAINT Situacao_valido CHECK(Situacao ILIKE 'Ativo' OR Situacao ILIKE 'Ferias' OR Situacao ILIKE 'Afastado')
);


