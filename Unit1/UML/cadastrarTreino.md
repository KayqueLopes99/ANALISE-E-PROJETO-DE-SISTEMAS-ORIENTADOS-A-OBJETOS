## UI02 - Cadastrar Treino
### 1. Descrição:
- É o processo onde o instrutor registra um contéudo no sistema sendo este um treino para os clientes da academia, adicionando cargas e relacionando aos respectivos clientes.  

### 2. Importância:
- Alta.

### 3. Ator Primário / Ator Secundário
- Primário: Instrutor

### 4. Pré-condições
- Instrutor precisa estar autenticado no sistema;
- O Aluno já deve estar previamente cadastrado no sistema.

### 5. Pós-condições
- O novo treino é salvo e fica disponível no perfil do Aluno.

### 6. Fluxo Principal

#### P1. Cadastrar Treino
##### P1.1 Instrutor seleciona a opção "Novo Treino";
##### P1.2 O Sistema solicita a identificação do Aluno para filtro de busca;
##### P1.3 O Instrutor seleciona o Aluno na lista;
##### P1.4 Sistema exibe a tela de cadastro com os campos a preencher relacionados ao treino; 
##### P1.5 O Instrutor seleciona na lista de exercicios os necessarios;
##### P1.6 Instrutor clica em "Salvar";
##### P1.7 O Sistema valida as informações e confirma o cadastro;

### 7. Fluxos Alternativos

#### A1. Buscar Aluno por Filtro Específico
##### A1.1 No passo **P1.2**, o Instrutor digita o nome, CPF ou matrícula do Aluno no campo de busca;
##### A1.2 O Sistema filtra os resultados e exibe apenas o Aluno correspondente;
##### A1.3 O fluxo retorna ao passo **P1.3** (O Instrutor seleciona o Aluno).

#### A2. Utilizar Modelo de Treino Predefinido
##### A2.1 No passo **P1.4**, o Instrutor seleciona a opção "Importar Modelo de Treino";
##### A2.2 O Sistema exibe uma lista de modelos pré-configurados;
##### A2.3 O Instrutor seleciona o modelo desejado;
##### A2.4 O Sistema preenche automaticamente a lista de exercícios, substituindo o passo **P1.5**;
##### A2.5 O Instrutor ajusta as cargas, se necessário;
##### A2.6 O fluxo retorna ao passo **P1.6** (Instrutor clica em "Salvar").


### 8. Fluxos de Exceção
E1. Aluno Inativo: Aluno com matrícula suspensa.
E2. Campos Obrigatórios Vazios: Ausencia de preenchimento de campos e seleção de salvamento.

### 9. Regras de Negócio: 
RN01 - Validade do Treino: Todo treino cadastrado deve ter uma data de expiração.
RN02 - Limite de Exercícios: Um único treino não pode conter mais de 15 exercícios.
RN03 - Unidade de Carga: O campo "Carga" deve aceitar apenas valores numéricos positivos.

-------------------------------------

#### 10. Histórico
- Data: 19/03/2026 - Versão Inicial - Responsável: José Kayque