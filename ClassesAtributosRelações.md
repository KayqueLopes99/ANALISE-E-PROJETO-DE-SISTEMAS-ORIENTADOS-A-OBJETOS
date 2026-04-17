# Documentação de Modelação: Sistema de Gestão de Biblioteca (SGB)
## 1. Dicionário de Entidades e Atributos

### 1.1 Entidades do Acervo

#### **Obra (Livro)**
*Representa o título no catálogo (metadados).*
- `idObra`: **int** (PK)
- `titulo`: **String**
- `autor`: **String**
- `isbn`: **String**
- `editora`: **String**
- `anoPublicacao`: **int**
- `edicao`: **String**
- `idioma`: **String**
- `sinopse`: **String**
- `urlCapa`: **String**
- `paginas`: **int**
- `categorias`: **List<Categoria>**

#### **Categoria**
- `idCategoria`: **int** (PK)
- `nome`: **String** (Ex: Literatura Brasileira, Cálculo, Engenharia)

#### **Exemplar**
*A unidade física que está na estante.*
- `idExemplar`: **int** (PK)
- `codigoBarras`: **String** (Único)
- `status`: **Enum** (Disponível, Emprestado, Reservado, Extraviado, Manutenção)
- `estadoConservacao`: **String**
- `idObra`: **int** (FK)
- `idLocalizacao`: **int** (FK)

#### **Localização**
- `idLocalizacao`: **int** (PK)
- `sala`: **String**
- `estante`: **String**
- `sessao`: **String**
- `descricao`: **String** (Ex: "Bloco A > Sala 2 > Estante 10")

---

### 1.2 Entidades de Usuário (Herança)

#### **Usuário (Classe Base/Abstrata)**
- `idUsuario`: **int** (PK)
- `nome`: **String**
- `email`: **String**
- `login`: **String**
- `senha`: **String**
- `tipoUsuario`: **Enum** (Leitor, Bibliotecário)

#### **Leitor (Herda de Usuário)**
- `cpf`: **String**
- `matricula`: **String**
- `statusLeitor`: **Enum** (Ativo, Suspenso)
- `dataCadastro`: **Date**
- `dataFimSuspensao`: **Date** (Guarda até quando o leitor está impedido de realizar novos empréstimos)

#### **Bibliotecário (Herda de Usuário)**
- `registroFuncional`: **String**

---

### 1.3 Entidades Transacionais (Operações)

#### **Empréstimo**
- `idEmprestimo`: **int** (PK)
- `dataEmprestimo`: **DateTime**
- `dataDevolucaoPrevista`: **Date**
- `dataDevolucaoReal`: **Date** (Null enquanto não devolvido)
- `quantidadeRenovacoes`: **int**
- `diasSuspensao`: **int** (Punição gerada por este atraso específico)
- `idLeitor`: **int** (FK)
- `idExemplar`: **int** (FK)

#### **Reserva**
- `idReserva`: **int** (PK)
- `dataReserva`: **DateTime**
- `statusReserva`: **Enum** (Pendente, Atendida, Expirada, Cancelada)
- `idLeitor`: **int** (FK)
- `idObra`: **int** (FK)

#### **Avaliação**
- `idAvaliacao`: **int** (PK)
- `nota`: **int** (1 a 5)
- `comentario`: **String**
- `dataAvaliacao`: **DateTime**
- `idLeitor`: **int** (FK)
- `idObra`: **int** (FK)

---

## 2. Mapeamento de Relacionamentos

### 2.1 Herança (Generalização)
- **Usuário 🠚 Leitor**: Um Leitor "é um" Usuário.
- **Usuário 🠚 Bibliotecário**: Um Bibliotecário "é um" Usuário.

### 2.2 Relacionamentos do Acervo
- **Obra — Categoria (N:N)**: Uma obra pode pertencer a várias categorias; uma categoria possui várias obras.
- **Obra — Exemplar (1:N)**: Uma obra possui um ou mais exemplares físicos.
- **Localização — Exemplar (1:N)**: Uma localização física pode abrigar vários exemplares.

### 2.3 Relacionamentos de Operações (Transacionais)
- **Leitor — Empréstimo (1:N)**: Um leitor pode ter múltiplos registros de empréstimos em seu histórico.
- **Exemplar — Empréstimo (1:N)**: Um exemplar pode ser emprestado várias vezes (histórico).
- **Leitor — Reserva (1:N)**: Um leitor pode realizar várias reservas de obras indisponíveis.
- **Obra — Reserva (1:N)**: Uma obra pode ter uma fila de reservas aguardando exemplares.

### 2.4 Relacionamentos de Interação
- **Leitor — Avaliação (1:N)**: Um leitor pode avaliar diversas obras.
- **Obra — Avaliação (1:N)**: Uma obra pode receber avaliações de diversos leitores.