# Lab 05 — Arquitetura Corporativa: Docker, Diagrama e Isolamento de Dados

> **Módulo:** 5 — Arquitetura Corporativa: Como LLMs Entram em Produção
> **Ambiente:** VM via Vagrant — Docker Compose + editor do host para o diagrama
> **Duração estimada:** 60–75 minutos

---

## Contexto do Ambiente

```bash
# No terminal do host:
vagrant ssh
docker compose version     # Docker Compose v2.x
systemctl status ollama    # Ollama do serviço: active (running), porta 11434
                           # A stack deste lab usa a porta 11435 para evitar conflito
```

Preencha este arquivo no editor do host — a pasta `labs/` é sincronizada com a VM.

---

## Parte 1 — Evidência da Stack em Execução

Após concluir as Etapas 1–4 do lab, registre aqui os outputs solicitados.

**Output de `docker compose ps`:**

```
[cole aqui]
```

**Output de `docker exec ollama-lab05 ollama list` (após o pull do phi3:mini):**

```
[cole aqui]
```

**Resposta da API do container (Etapa 3 — chamada de inferência):**

```
[cole aqui a resposta gerada pelo modelo]
```

**Output de `docker exec ollama-lab05 ollama list` após `docker compose down` + `docker compose up -d` (Etapa 4):**

```
[cole aqui — phi3:mini deve continuar listado]
```

**O modelo persistiu após derrubar e subir novamente?** `[ ] Sim  [ ] Não`

Se não persistiu, o que pode ter causado isso?

> Resposta:

---

## Parte 2 — Diagrama de Arquitetura Corporativa

A **Meridional Consultoria** está migrando seu assistente interno de LLM de uma POC para um serviço corporativo compartilhado entre os departamentos de RH e Jurídico. O arquiteto esboçou a estrutura, mas deixou quatro posições em aberto.

### O Diagrama Incompleto

```
[Depto RH]        [Depto Jurídico]
    │                    │
    └──────────┬──────────┘
               │
               ▼
        [??? Componente A ???]
               │
               ▼
        [??? Componente B ???]
               │
               ├──────────────────────┐
               ▼                      ▼
    [??? Componente C ???]   [??? Componente D ???]
               │
               ▼
    ┌──────────────────────┐
    │  Servidor Ollama     │
    │  (mistral:7b-q4_K_M) │
    └──────────────────────┘
```

### Os Quatro Componentes a Posicionar

| Componente | O que faz |
|:-----------|:----------|
| **Container de inferência** | Empacota o Ollama e o modelo em um artefato portável e versionável; garante que o mesmo ambiente rode em dev, staging e produção sem variações de configuração |
| **Gateway de API (ex: LiteLLM)** | Ponto único de entrada para todas as aplicações; aplica rate limiting, roteia para o servidor correto, transforma requests — sem que o servidor de inferência precise lidar com isso |
| **Autenticação / IAM** | Verifica identidade de quem requisita e determina permissões; vincula cada chamada a um usuário identificado — necessário para atender Art. 18 da LGPD |
| **Logging / Observabilidade (ex: Langfuse)** | Registra prompt, resposta, usuário, tokens consumidos, latência — base para auditoria, debugging e conformidade com LGPD |

### Diagrama Preenchido

Substitua cada `[??? Componente X ???]` pelo nome do componente que você escolheu para aquela posição:

```
[Depto RH]        [Depto Jurídico]
    │                    │
    └──────────┬──────────┘
               │
               ▼
        [Componente A = ________________________]
               │
               ▼
        [Componente B = ________________________]
               │
               ├──────────────────────┐
               ▼                      ▼
    [Componente C = ____________]  [Componente D = ____________]
               │
               ▼
    ┌──────────────────────┐
    │  Servidor Ollama     │
    │  (mistral:7b-q4_K_M) │
    └──────────────────────┘
```

### Justificativas

**Componente A** — por que esse componente vai nessa posição (primeira camada após os clientes)?

> Resposta:

**Componente B** — por que esse componente vem depois do A?

> Resposta:

**Componente C** — qual é a relação deste componente com o servidor de inferência?

> Resposta:

**Componente D** — por que esse componente fica em paralelo com C, e não em série antes dele?

> Resposta:

---

## Parte 3 — Perguntas de Análise

**1.** No lab, o Ollama do serviço systemd (porta `11434`) e o Ollama do container Docker (porta `11435`) rodaram ao mesmo tempo na mesma VM. Em produção, você teria as duas instâncias rodando assim? O que determinaria a escolha entre uma e outra?

> Resposta:

**2.** Os departamentos de RH e Jurídico compartilham o mesmo servidor de inferência (multi-tenant). Um advogado do Jurídico enviou um prompt contendo minutas confidenciais de um contrato de M&A. Qual dos quatro componentes é o responsável por garantir que esse conteúdo não apareça no contexto de uma requisição do RH? Descreva o mecanismo técnico.

> Resposta:

**3.** No Componente de Logging, os prompts dos usuários são registrados. Se esses prompts contiverem dados pessoais de clientes — nomes, CPFs, histórico médico — o que a LGPD exige da empresa em relação a esses logs?

> Resposta:

---

<details>
<summary>Gabarito orientativo — abra somente após preencher</summary>

**Diagrama:**
- **A = Gateway de API (LiteLLM)** — primeiro ponto de entrada unificado; aplica rate limiting e roteamento antes de qualquer outra camada
- **B = Autenticação / IAM** — logo após o gateway, antes de chegar ao roteamento interno; identifica quem está fazendo a requisição e com quais permissões
- **C = Container de inferência** — empacota o Ollama; posicionado próximo ao servidor de inferência porque é sua camada de runtime
- **D = Logging / Observabilidade** — em paralelo com o container de inferência; intercepta o fluxo para registrar sem bloquear a resposta ao usuário

**Pergunta 1:** Em produção, você escolheria um ou outro, não os dois. O serviço systemd é adequado para ambientes sem containers; Docker é preferível quando você quer isolamento, versionamento e portabilidade. O critério de escolha é o nível de maturidade de infraestrutura da organização e se o ambiente de produção já usa orquestração de containers.

**Pergunta 2:** A Autenticação / IAM, em conjunto com o gerenciamento de sessão na camada de aplicação. O IAM vincula cada requisição a uma identidade com permissões definidas. O isolamento de contexto é garantido por sessão: cada requisição ao modelo carrega apenas seu próprio histórico — não há memória compartilhada entre usuários a menos que o código da aplicação construa isso explicitamente. Um bug no gerenciamento de sessão que misture contextos é um incidente de segurança.

**Pergunta 3:** Os logs contêm dados pessoais e estão sob escopo da LGPD. A empresa precisa: (1) definir e documentar a base legal para esse tratamento (Art. 7); (2) estabelecer política de retenção — quanto tempo os logs ficam armazenados e por quê; (3) restringir acesso aos logs a pessoal autorizado; (4) ter processo para atender pedidos de exclusão de dados (Art. 18) — o que pode ser complexo se os dados pessoais estiverem misturados com logs de sistema.

</details>

---

*Lab 05 — Módulo 5, Curso 1 da Trilha IA Open Source 4Linux.*
