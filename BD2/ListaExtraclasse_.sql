CREATE TABLE EQUIPAMENTO(
	idEquipamento VARCHAR(6) PRIMARY KEY,
	nomeEquipamento VARCHAR(100) NOT NULL,
	descricao VARCHAR(300) NOT NULL,
	valor NUMERIC(10,2) NOT NULL CONSTRAINT valor_positivo CHECK(valor > 0.0),
	dataAquisicao DATE NOT NULL CONSTRAINT data_valida CHECK(dataAquisicao <= CURRENT_DATE)
);

CREATE TYPE tipo AS ENUM ('Aluno', 'Professor', 'Diretor', 'Outro');

CREATE TABLE RESPONSAVEL(
	CPF VARCHAR(11) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	tipoResponsavel tipo,
	dataNascimento DATE CONSTRAINT dataNasc_valida CHECK(dataNascimento <= CURRENT_DATE)
);
CREATE TABLE EMPRESTIMO(
	CPF VARCHAR(11), 
	idEquipamento VARCHAR(6),
);	
