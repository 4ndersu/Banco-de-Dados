-- 1. BLOCO DE INFRAESTRUTURA E PRODUTOS

CREATE TABLE LOJA (
    
CNPJ varchar(14) PRIMARY KEY,
nomeFantasia varchar(100) NOT NULL UNIQUE,
endCEP varchar(8) NOT NULL,
endRua varchar(100) NOT NULL,
endNumero int NOT NULL,

--Check Constraint para numero de endereço positivo
CONSTRAINT endNumero_positivo CHECK (endNumero > 0)
);

CREATE TABLE CONTATO_LOJA (

idCONTATO_LOJA varchar(10) PRIMARY KEY,
tipo varchar(45) NOT NULL,
conteudo varchar(100) NOT NULL,
LOJA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_contatoLoja_Loja
FOREIGN KEY (LOJA_CNPJ)
REFERENCES LOJA (CNPJ)
);

CREATE TABLE PRODUTO (

idProduto varchar(13) PRIMARY KEY,
infTitulo varchar(100) NOT NULL,
infDescricao varchar(300) NOT NULL,
estoque int NOT NULL,
preco decimal(6,2) NOT NULL,
promocao decimal(4,2),
LOJA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Produto_Loja
FOREIGN KEY (LOJA_CNPJ)
REFERENCES LOJA (CNPJ),

--Check Constraint para numero de endereço positivo
CONSTRAINT estoque_positivo CHECK (estoque >= 0),
CONSTRAINT promocao_positivo CHECK (promocao >= 0),
CONSTRAINT preco_positivo CHECK (preco > 0)
);

CREATE TABLE TIPO (

idTipo int PRIMARY KEY,
tipo varchar(45) NOT NULL
);

CREATE TABLE TIPO_PRODUTO (

PRODUTO_ID varchar(13),
TIPO_ID int,

PRIMARY KEY (PRODUTO_ID, TIPO_ID),

CONSTRAINT fk_Produto_Tipo
FOREIGN KEY (PRODUTO_ID)
REFERENCES PRODUTO (idProduto),

CONSTRAINT fk_Tipo_Produto
FOREIGN KEY (TIPO_ID)
REFERENCES TIPO (idTipo)
);

-- 2. BLOCO DE PARCEIROS (FORNECEDORES E LOGÍSTICA)

CREATE TABLE FORNECEDOR (

CNPJ varchar(14) PRIMARY KEY,
nomeFantasia varchar(100) NOT NULL UNIQUE,
endCEP varchar(8) NOT NULL,
endRua varchar(100) NOT NULL,
endNumero int NOT NULL,

--Check Constraint para numero de endereço positivo
CONSTRAINT endNumero_positivo CHECK (endNumero > 0)
);

CREATE TABLE CONTATO_FORNECEDOR (

idCONTATO_FORNECEDOR varchar(10) PRIMARY KEY,
tipo varchar(45) NOT NULL,
conteudo varchar(100) NOT NULL,
FORNECEDOR_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Contato_Fornecedor
FOREIGN KEY (FORNECEDOR_CNPJ)
REFERENCES FORNECEDOR (CNPJ)
);

CREATE TABLE TRANSPORTADORA (

CNPJ varchar(14) PRIMARY KEY,
nomeFantasia varchar(100) NOT NULL UNIQUE,
endCEP varchar(8) NOT NULL,
endRua varchar(100) NOT NULL,
endNumero int NOT NULL,
precoFrete decimal(6,2) NOT NULL,
DataReceb date NOT NULL,
Prazo int NOT NULL,
DataEntrega date NOT NULL,

--Check Constraint para numero de endereço e frete positivo
CONSTRAINT endNumero_positivo CHECK (endNumero > 0),
CONSTRAINT precoFrete_positivo CHECK (precoFrete >= 0)
);

CREATE TABLE CONTATO_TRANSPORTADORA (

idCONTATO_TRANSPORTADORA varchar(10) PRIMARY KEY,
tipo varchar(45) NOT NULL,
conteudo varchar(100) NOT NULL,
TRANSPORTADORA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Contato_Transportadora
FOREIGN KEY (TRANSPORTADORA_CNPJ)
REFERENCES TRANSPORTADORA (CNPJ)
);

CREATE TABLE VEICULO (

placaVEICULO varchar(7) PRIMARY KEY,
tipoVeiculo varchar(45) NOT NULL,
capacidade decimal(6,2) NOT NULL,
TRANSPORTADORA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Veiculo_Transportadora
FOREIGN KEY (TRANSPORTADORA_CNPJ)
REFERENCES TRANSPORTADORA (CNPJ),

--Check Constraint para capacidade positiva
CONSTRAINT capacidade_positivo CHECK (capacidade >= 0)
);

CREATE TABLE LOTE (

PRODUTO_ID varchar(13),
COD varchar(20),
qtd int NOT NULL,
preco decimal(6,2) NOT NULL,
dimAltura decimal(4,2) NOT NULL,
dimPeso decimal(5,2) NOT NULL,
valDataFab date NOT NULL,
valPeriodoVal int NOT NULL,
valDataVal date,
FORNECEDOR_CNPJ varchar(14) NOT NULL,
TRANSPORTADORA_CNPJ varchar(14) NOT NULL,

PRIMARY KEY (PRODUTO_ID, COD),

CONSTRAINT fk_Lote_Produto
FOREIGN KEY (PRODUTO_ID)
REFERENCES PRODUTO (idProduto),

CONSTRAINT fk_Lote_Fornecedor
FOREIGN KEY (FORNECEDOR_CNPJ)
REFERENCES FORNECEDOR (CNPJ),

CONSTRAINT fk_Lote_Transportadora
FOREIGN KEY (TRANSPORTADORA_CNPJ)
REFERENCES TRANSPORTADORA (CNPJ),

--Check Constraint para quantidade, preco e dimensoes positiva
CONSTRAINT qtd_positivo CHECK (qtd >= 0),
CONSTRAINT preco_positivo CHECK (preco > 0),
CONSTRAINT dimAltura_positivo CHECK (dimAltura > 0),
CONSTRAINT dimPeso_positivo CHECK (dimPeso > 0)
);

-- 3. BLOCO DE CLIENTES E SAÚDE

CREATE TABLE CLIENTE (

CPF varchar(11) PRIMARY KEY,
nomeCompleto varchar(100) NOT NULL,
dataNasc date NOT NULL,
perfilTamanho decimal(3,2) NOT NULL,
perfilPeso decimal(5,2) NOT NULL,
telefone varchar(11) NOT NULL UNIQUE,
email varchar(100),
LOJA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Cliente_Loja
FOREIGN KEY (LOJA_CNPJ)
REFERENCES LOJA (CNPJ),

--Check Constraint para tamanho e peso positivo
CONSTRAINT tamanho_positivo CHECK (perfilTamanho > 0),
CONSTRAINT peso_positivo CHECK (perfilPeso > 0)
);

CREATE TABLE CONDICAO (

idCondicao int PRIMARY KEY,
condicao varchar(45)
);

CREATE TABLE CLIENTE_CONDICAO (

CLIENTE_CPF varchar(11),
ID_CONDICAO int,

PRIMARY KEY (CLIENTE_CPF, ID_CONDICAO),

CONSTRAINT fk_Cliente_Condicao
FOREIGN KEY (CLIENTE_CPF)
REFERENCES CLIENTE (CPF),

CONSTRAINT fk_Condicao_Cliente
FOREIGN KEY (ID_CONDICAO)
REFERENCES CONDICAO (idCondicao)
);

-- 4. BLOCO DE FUNCIONÁRIOS

CREATE TABLE FUNCIONARIO (

CPF varchar(11) PRIMARY KEY,
nomeCompleto varchar(100) NOT NULL,
horario char(5) NOT NULL,
salario decimal(6,2) NOT NULL,
LOJA_CNPJ varchar(14) NOT NULL,

CONSTRAINT fk_Funcionario_Loja
FOREIGN KEY (LOJA_CNPJ)
REFERENCES LOJA (CNPJ),

--Check Constraint para salario positivo
CONSTRAINT salario_positivo CHECK (salario > 0)
);

CREATE TABLE CONTATO_FUNCIONARIO (

idCONTATO_FUNCIONARIO varchar(10) PRIMARY KEY,
tipo varchar(45) NOT NULL,
conteudo varchar(100) NOT NULL,
FUNCIONARIO_CPF varchar(11) NOT NULL,

CONSTRAINT fk_contatoFuncionario_Funcionario
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES FUNCIONARIO (CPF)
);

-- ESPECIALIZAÇÕES --

CREATE TABLE ZELADOR (

FUNCIONARIO_CPF varchar(11) PRIMARY KEY,
tipoManutencao varchar(20) NOT NULL,

CONSTRAINT fk_Zelador_Funcionario
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES FUNCIONARIO (CPF)
);

CREATE TABLE EQUIPAMENTO (

idEquipamento int PRIMARY KEY,
equipamento varchar(45)
);

CREATE TABLE EQUIPAMENTO_ZELADOR (

EQUIPAMENTO_ID int,
ZELADOR_CPF varchar(11),

PRIMARY KEY (EQUIPAMENTO_ID, ZELADOR_CPF),

CONSTRAINT fk_Equipamento_Zelador
FOREIGN KEY (EQUIPAMENTO_ID)
REFERENCES EQUIPAMENTO (idEquipamento),

CONSTRAINT fk_Zelador_Equipamento
FOREIGN KEY (ZELADOR_CPF)
REFERENCES ZELADOR (FUNCIONARIO_CPF)
);

CREATE TABLE GERENTE (

FUNCIONARIO_CPF varchar(11) PRIMARY KEY,
nivelAcesso int NOT NULL,
dataPosse date NOT NULL,

CONSTRAINT fk_Gerente_Funcionario
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES FUNCIONARIO (CPF),

--Check Constraint para nivelAcesso positivo
CONSTRAINT nivelAcesso_positivo CHECK (nivelAcesso >= 0)
);

CREATE TABLE SEGURANCA (

FUNCIONARIO_CPF varchar(11) PRIMARY KEY,
areaProtecao varchar(45) NOT NULL,
posseArma boolean NOT NULL,

CONSTRAINT fk_Seguranca_Funcionario
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES FUNCIONARIO (CPF)
);

CREATE TABLE VENDEDOR (

FUNCIONARIO_CPF varchar(11) PRIMARY KEY,
certificacao varchar(45) NOT NULL,
percentualComissao decimal(4,2) NOT NULL,

CONSTRAINT fk_Vendedor_Funcionario
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES FUNCIONARIO (CPF),

--Check Constraint para percentual comissao positivo
CONSTRAINT percComissao_positivo CHECK (percentualComissao >= 0)
);

-- 5. BLOCO DE VENDAS
CREATE TABLE TRANSACAO (

idVenda varchar(9) PRIMARY KEY,
dataHora timestamp NOT NULL,
formaPagamento varchar(45) NOT NULL,
CLIENTE_CPF varchar(11) NOT NULL,
FUNCIONARIO_CPF varchar(11) NOT NULL,

CONSTRAINT fk_Transacao_Cliente
FOREIGN KEY (CLIENTE_CPF)
REFERENCES CLIENTE (CPF),

CONSTRAINT fk_Transacao_Vendedor
FOREIGN KEY (FUNCIONARIO_CPF)
REFERENCES VENDEDOR (FUNCIONARIO_CPF)
);

CREATE TABLE ITEM_TRANSACAO (

TRANSACAO_idvenda varchar(9),
PRODUTO_ID varchar(13),
qtdProduto int NOT NULL,
precoPraticado decimal(6,2) NOT NULL,

PRIMARY KEY (TRANSACAO_idvenda, PRODUTO_ID),

CONSTRAINT fk_Item_Transacao
FOREIGN KEY (TRANSACAO_idvenda)
REFERENCES TRANSACAO (idVenda),

CONSTRAINT fk_Item_Produto
FOREIGN KEY (PRODUTO_ID)
REFERENCES PRODUTO (idProduto),

--Check Constraint para quantidade e preco da transacao positivo
CONSTRAINT qtd_positivo CHECK (qtdProduto > 0),
CONSTRAINT precoPraticado_positivo CHECK (precoPraticado > 0)
);