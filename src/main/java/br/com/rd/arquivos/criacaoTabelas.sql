-- 1� CAMADA - SEM ATRIBUTO (FK)

-- >>>>>>>>>>>>>>>>> PRODUTO
CREATE TABLE TB_CATEGORIA_PRODUTO (
	CODIGO_CATEGORIA TINYINT NOT NULL,
	DESCRICAO VARCHAR(75) NOT NULL,
	PRIMARY KEY(CODIGO_CATEGORIA)
);

CREATE TABLE TB_COLECAO (
	CODIGO_COLECAO TINYINT NOT NULL,
	DESCRICAO VARCHAR(75) NOT NULL,
	PRIMARY KEY (CODIGO_COLECAO)
);

CREATE TABLE TB_RARIDADE (
	CODIGO_RARIDADE TINYINT NOT NULL,
	DESCRICAO VARCHAR(75) NOT NULL,
	PRIMARY KEY(CODIGO_RARIDADE)
);

CREATE TABLE TB_CATEGORIA_PRECO (
	CODIGO_CATEGORIA_PRECO TINYINT NOT NULL,
	DESCRICAO VARCHAR(45) NOT NULL,
	PRIMARY KEY (CODIGO_CATEGORIA_PRECO)
);

CREATE TABLE TB_FORNECEDOR (
	CODIGO_FORNECEDOR INT NOT NULL,
	CNPJ CHAR(14) NOT NULL,
	DESCRICAO VARCHAR(45) NOT NULL,
	PRIMARY KEY (CODIGO_FORNECEDOR)
);


-- >>>>>>>>>>>>>>>>> CLIENTE
CREATE TABLE TB_TELEFONE (
	CODIGO_TELEFONE INT NOT NULL,
	DDD CHAR(2) NOT NULL,
	NUMERO_TELEFONE VARCHAR(9) NOT NULL,
	PRIMARY KEY(CODIGO_TELEFONE)
);


-- >>>>>>>>>>>>>>>>> MVP SKINS
CREATE TABLE TB_PIX(
	CHAVE_PIX VARCHAR(45) NOT NULL,
	INSTITUICAO_FINANCEIRA VARCHAR(45) NOT NULL,
	NUMERO_CONTA TINYINT NOT NULL,
	NUMERO_AGENCIA TINYINT NOT NULL,
	PRIMARY KEY(CHAVE_PIX)
);


-- >>>>>>>>>>>>>>>>> NF
CREATE TABLE TB_FORMA_PAGAMENTO(
	CODIGO_FORMA_PAGAMENTO TINYINT NOT NULL,
	DESCRICAO VARCHAR(45) NOT NULL,
	PRIMARY KEY (CODIGO_FORMA_PAGAMENTO)
);

CREATE TABLE TB_TIPO_NF(
	CODIGO_TIPO_NF TINYINT NOT NULL,
	DESCRICAO VARCHAR(45) NOT NULL,
	PRIMARY KEY (CODIGO_TIPO_NF)
);



-- 2� CAMADA - APENAS UM ATRIBUTO (FK)

-- >>>>>>>>>>>>>>>>> PRODUTOS
CREATE TABLE TB_SUBCATEGORIA_PRODUTO(
	CODIGO_SUBCATEGORIA TINYINT NOT NULL,
	CODIGO_CATEGORIA TINYINT NOT NULL,
	DESCRICAO VARCHAR(75) NOT NULL,
	PRIMARY KEY (CODIGO_SUBCATEGORIA, CODIGO_CATEGORIA),
	FOREIGN KEY (CODIGO_CATEGORIA) REFERENCES TB_CATEGORIA_PRODUTO(CODIGO_CATEGORIA)
);



-- 3� CAMADA - TABELAS CENTRAIS

-- >>>>>>>>>>>>>>>>> PRODUTOS
CREATE TABLE TB_PRODUTO (
	CODIGO_PRODUTO BIGINT NOT NULL,
	DESCRICAO VARCHAR(75) NOT NULL,
	CODIGO_CATEGORIA TINYINT NOT NULL,
	CODIGO_SUBCATEGORIA TINYINT NOT NULL,
	CODIGO_COLECAO TINYINT NOT NULL,
	CODIGO_RARIDADE TINYINT NOT NULL,
	FLOAT_DESGASTE DECIMAL(9,8) NOT NULL,
	EXTERIOR VARCHAR(45) NOT NULL,
	PARTNER BIGINT NOT NULL,
	TRADE_LOCK TINYINT NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_CATEGORIA) REFERENCES TB_CATEGORIA_PRODUTO(CODIGO_CATEGORIA),
	FOREIGN KEY (CODIGO_SUBCATEGORIA) REFERENCES TB_SUBCATEGORIA_PRODUTO(CODIGO_SUBCATEGORIA) ,
	FOREIGN KEY (CODIGO_COLECAO) REFERENCES TB_COLECAO(CODIGO_COLECAO),
	FOREIGN KEY (CODIGO_RARIDADE) REFERENCES TB_RARIDADE(CODIGO_RARIDADE)
);

CREATE TABLE TB_PROMOCAO (
	CODIGO_PROMOCAO VARCHAR(20) NOT NULL,
	CODIGO_PRODUTO BIGINT NULL,
	CODIGO_CATEGORIA TINYINT NULL,
	CODIGO_SUBCATEGORIA TINYINT NULL,
	DESCRICAO VARCHAR(35) NOT NULL,
	PORCENTAGEM_DESCONTO DECIMAL(4,2) NULL,
	VALOR_DESCONTO DECIMAL(5,2) NULL,
	DATA_INICIO DATETIME NOT NULL,
	DATA_FIM DATETIME NULL,
	PRIMARY KEY (CODIGO_PROMOCAO),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_CATEGORIA) REFERENCES TB_CATEGORIA_PRODUTO(CODIGO_CATEGORIA),
	FOREIGN KEY (CODIGO_SUBCATEGORIA) REFERENCES TB_SUBCATEGORIA_PRODUTO(CODIGO_SUBCATEGORIA)
);


-- >>>>>>>>>>>>>>>>> CLIENTE
CREATE TABLE TB_CLIENTE	 (
	CODIGO_CLIENTE BIGINT NOT NULL,
	CODIGO_TELEFONE INT NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	GENERO VARCHAR(20) NOT NULL,
	DATA_NASCIMENTO DATE NOT NULL,
	TRADE_LINK VARCHAR(100) NOT NULL,
	SENHA VARCHAR(45) NOT NULL,
	PRIMARY KEY (CODIGO_CLIENTE),
	FOREIGN KEY (CODIGO_TELEFONE) REFERENCES TB_TELEFONE(CODIGO_TELEFONE)
);


-- >>>>>>>>>>>>>>>>> EMPRESA
CREATE TABLE TB_EMPRESA (
	CODIGO_EMPRESA TINYINT NOT NULL,
	CODIGO_TELEFONE INT NOT NULL,
	CNPJ CHAR(14) NOT NULL UNIQUE,
	DESCRICAO VARCHAR(44) NULL,
	INSCRICAO_ESTADUAL CHAR(9) NOT NULL,
	PRIMARY KEY (CODIGO_EMPRESA),
	FOREIGN KEY (CODIGO_TELEFONE) REFERENCES TB_TELEFONE(CODIGO_TELEFONE)
);

CREATE TABLE TB_CONTA_STEAM (
	CODIGO_CONTA_STEAM TINYINT NOT NULL,
	CODIGO_EMPRESA TINYINT NOT NULL,
	EMAIL VARCHAR(50) NOT NULL UNIQUE,
	SENHA_EMAIL VARCHAR(45) NOT NULL,
	TRADE_LINK VARCHAR(100) NOT NULL,
	PRIMARY KEY (CODIGO_CONTA_STEAM),
	FOREIGN KEY (CODIGO_EMPRESA) REFERENCES TB_EMPRESA(CODIGO_EMPRESA)
);


-- >>>>>>>>>>>>>>>>> NF
CREATE TABLE TB_PEDIDO (
	CODIGO_PEDIDO BIGINT NOT NULL,
	CODIGO_EMPRESA SMALLINT NULL,
	CODIGO_CLIENTE INT NULL,
	CODIGO_FORMA_PAGAMENTO TINYINT NOT NULL,
	DATA_EMISSAO DATETIME NOT NULL,
	DESCONTO_PRODUTO DECIMAL(12,4) NULL,
	VALOR_TOTAL_BRUTO DECIMAL(12,4) NOT NULL,
	VALOR_TOTAL_LIQUIDO DECIMAL(12,4) NOT NULL,
	PRIMARY KEY (CODIGO_PEDIDO),
	FOREIGN KEY (CODIGO_EMPRESA) REFERENCES TB_EMPRESA(CODIGO_EMPRESA),
	FOREIGN KEY (CODIGO_CLIENTE) REFERENCES TB_CLIENTE(CODIGO_CLIENTE),
	FOREIGN KEY (CODIGO_FORMA_PAGAMENTO) REFERENCES TB_FORMA_PAGAMENTO(CODIGO_FORMA_PAGAMENTO)
);

CREATE TABLE TB_NF (
	CODIGO_NF BIGINT NOT NULL,
	CODIGO_PEDIDO BIGINT NOT NULL,
	CODIGO_TIPO_NF TINYINT NOT NULL,
	CODIGO_EMPRESA TINYINT NULL,
	CODIGO_FORNECEDOR INT NULL,
	CODIGO_CLIENTE BIGINT NULL,
	CODIGO_FORMA_PAGAMENTO TINYINT NOT NULL,
	CHAVE_DE_ACESSO CHAR(44) NOT NULL UNIQUE,
	NUMERO_NOTA CHAR(9) NOT NULL,
	ICMS_TOTAL DECIMAL(12,4)  NOT NULL,
	IPI_TOTAL DECIMAL(12,4) NOT NULL,
	PIS_TOTAL DECIMAL(12,4)  NOT NULL,
	COFINS_TOTAL DECIMAL(12,4)  NOT NULL,
	FLAG_NOTA_PAULISTA BIT NOT NULL,
	DATA_EMISSAO DATETIME NOT NULL,
	DESCONTO_PRODUTO DECIMAL(12,4) NULL,
	VALOR_TOTAL_BRUTO DECIMAL(12,4) NOT NULL,
	VALOR_TOTAL_LIQUIDO DECIMAL(12,4) NOT NULL,
	PRIMARY KEY (CODIGO_NF),
	FOREIGN KEY (CODIGO_TIPO_NF) REFERENCES TB_TIPO_NF(CODIGO_TIPO_NF),
	FOREIGN KEY (CODIGO_PEDIDO) REFERENCES TB_PEDIDO(CODIGO_PEDIDO),
	FOREIGN KEY (CODIGO_EMPRESA) REFERENCES TB_EMPRESA(CODIGO_EMPRESA),
	FOREIGN KEY (CODIGO_FORNECEDOR) REFERENCES TB_FORNECEDOR(CODIGO_FORNECEDOR),
	FOREIGN KEY (CODIGO_CLIENTE) REFERENCES TB_CLIENTE(CODIGO_CLIENTE),
	FOREIGN KEY (CODIGO_FORMA_PAGAMENTO) REFERENCES TB_FORMA_PAGAMENTO(CODIGO_FORMA_PAGAMENTO)
);


-- 4� CAMADA - TABELAS COMPOSTAS

-- >>>>>>>>>>>>>>>>> PRODUTO
CREATE TABLE TB_FAVORITOS (
	CODIGO_PRODUTO BIGINT NOT NULL,
	CODIGO_CLIENTE BIGINT NOT NULL,
	FLAG_FAVORITO BIT NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO, CODIGO_CLIENTE),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_CLIENTE) REFERENCES TB_CLIENTE(CODIGO_CLIENTE)
);

CREATE TABLE TB_PRECO(
	CODIGO_PRODUTO BIGINT NOT NULL,
	CODIGO_CATEGORIA_PRECO TINYINT NOT NULL,
	DATA_VIGENCIA DATE NOT NULL,
	VALOR_PRECO DECIMAL(12,4) NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO, CODIGO_CATEGORIA_PRECO, DATA_VIGENCIA),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_CATEGORIA_PRECO) REFERENCES TB_CATEGORIA_PRECO(CODIGO_CATEGORIA_PRECO),
);

CREATE TABLE TB_ESTOQUE (
	CODIGO_PRODUTO BIGINT NOT NULL,
	CODIGO_CONTA_STEAM TINYINT NOT NULL,
	QUANTIDADE TINYINT NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO, CODIGO_CONTA_STEAM),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_CONTA_STEAM) REFERENCES TB_CONTA_STEAM(CODIGO_CONTA_STEAM)
);

CREATE TABLE TB_ITENS_NF (
	CODIGO_PRODUTO BIGINT NOT NULL,
	CODIGO_NF BIGINT NOT NULL,
	QUANTIDADE INT NOT NULL,
	ICMS DECIMAL(12,4) NOT NULL,
	PIS DECIMAL(12,4)  NOT NULL,
	COFINS  DECIMAL(12,4)  NOT NULL,
	IPI DECIMAL(12,4) NOT NULL,
	DESCONTO(12,4) NOT NULL,
	VALOR_BRUTO DECIMAL(12,4) NOT NULL,
	VALOR_LIQUIDO DECIMAL(12,4) NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO, CODIGO_NF),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_NF) REFERENCES TB_NF(CODIGO_NF)

);

CREATE TABLE TB_ITENS_PEDIDO (
	CODIGO_PRODUTO(PK, FK) BIGINT NOT NULL,
	CODIGO_PEDIDO(PK, FK) BIGINT NOT NULL,
	QUANTIDADE INT NOT NULL,
	DESCONTO(12,4) NOT NULL,
	VALOR_BRUTO DECIMAL(12,4) NOT NULL,
	VALOR_LIQUIDO DECIMAL(12,4) NOT NULL,
	PRIMARY KEY (CODIGO_PRODUTO, CODIGO_NOTA),
	FOREIGN KEY (CODIGO_PRODUTO) REFERENCES TB_PRODUTO(CODIGO_PRODUTO),
	FOREIGN KEY (CODIGO_PEDIDO) REFERENCES TB_PEDIDO(CODIGO_PEDIDO),
);
