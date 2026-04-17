-- =================================================================================
-- SCRIPT POSTGRESQL - SISTEMA DE GESTÃO DE BIBLIOTECA (SGB)
-- Estratégia: Single Table Inheritance (Herança de Tabela Única)
-- =================================================================================

-- 1. Criação dos Tipos ENUM
CREATE TYPE tipo_usuario AS ENUM ('LEITOR', 'BIBLIOTECARIO');
CREATE TYPE status_leitor AS ENUM ('ATIVO', 'SUSPENSO');
CREATE TYPE status_exemplar AS ENUM ('DISPONIVEL', 'EMPRESTADO', 'RESERVADO', 'MANUTENCAO');
CREATE TYPE status_reserva AS ENUM ('PENDENTE', 'ATENDIDA', 'EXPIRADA', 'CANCELADA');

-- =================================================================================
-- 2. Entidade de Usuário (Tabela Única para Leitor e Bibliotecário)
-- =================================================================================

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    
    -- Atributos Comuns (Abstrata Usuario)
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    login VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario tipo_usuario NOT NULL,
    
    -- Atributos Específicos do Leitor (Podem ser NULL)
    cpf VARCHAR(14) UNIQUE,
    matricula VARCHAR(50) UNIQUE,
    status_leitor status_leitor DEFAULT 'ATIVO',
    data_cadastro DATE,
    data_fim_suspensao DATE,
    
    -- Atributos Específicos do Bibliotecário (Podem ser NULL)
    registro_funcional VARCHAR(50) UNIQUE,
    
    -- REGRA DE OURO: Garante que cada tipo preencha seus campos obrigatórios
    CONSTRAINT check_dados_heranca CHECK (
        (tipo_usuario = 'LEITOR' AND cpf IS NOT NULL AND matricula IS NOT NULL AND data_cadastro IS NOT NULL) OR
        (tipo_usuario = 'BIBLIOTECARIO' AND registro_funcional IS NOT NULL)
    )
);

-- =================================================================================
-- 3. Entidades do Acervo
-- =================================================================================

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE obra (
    id_obra SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    editora VARCHAR(150),
    ano_publicacao INT,
    edicao VARCHAR(50),
    idioma VARCHAR(50),
    sinopse TEXT,
    url_capa VARCHAR(500), ----------------------------------------------------- <
    paginas INT
    -- 'isDisponivel' omitido por ser atributo derivado (calculável via lógica/query)
);

-- Tabela de Resolução do Relacionamento Muitos-para-Muitos (N:N)
CREATE TABLE obra_categoria (
    id_obra INT NOT NULL,
    id_categoria INT NOT NULL,
    PRIMARY KEY (id_obra, id_categoria),
    FOREIGN KEY (id_obra) REFERENCES obra(id_obra) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE
);

CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    sala VARCHAR(100),
    estante VARCHAR(50),
    sessao VARCHAR(50),
    descricao TEXT
);

CREATE TABLE exemplar (
    id_exemplar SERIAL PRIMARY KEY,
    codigo_barras VARCHAR(100) UNIQUE NOT NULL,
    status status_exemplar DEFAULT 'DISPONIVEL',
    estado_conservacao VARCHAR(150),
    id_obra INT NOT NULL,
    id_localizacao INT,
    FOREIGN KEY (id_obra) REFERENCES obra(id_obra) ON DELETE CASCADE,
    FOREIGN KEY (id_localizacao) REFERENCES localizacao(id_localizacao) ON DELETE SET NULL
);

-- =================================================================================
-- 4. Entidades Transacionais (Operações)
-- =================================================================================

CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    quantidade_renovacoes INT DEFAULT 0,
    dias_suspensao INT DEFAULT 0,
    id_leitor INT NOT NULL, 
    id_exemplar INT NOT NULL,
    FOREIGN KEY (id_leitor) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    FOREIGN KEY (id_exemplar) REFERENCES exemplar(id_exemplar) ON DELETE RESTRICT
);

CREATE TABLE reserva (
    id_reserva SERIAL PRIMARY KEY,
    data_reserva TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_reserva status_reserva DEFAULT 'PENDENTE',
    id_leitor INT NOT NULL, 
    id_obra INT NOT NULL,
    FOREIGN KEY (id_leitor) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_obra) REFERENCES obra(id_obra) ON DELETE CASCADE
);

CREATE TABLE avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5), 
    comentario TEXT,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_leitor INT NOT NULL, 
    id_obra INT NOT NULL,
    FOREIGN KEY (id_leitor) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_obra) REFERENCES obra(id_obra) ON DELETE CASCADE
);