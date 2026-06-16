# Template — Projeto Integrador

> **Módulo:** 7 — Casos Reais e Projeto Integrador
> **Ambiente:** VM via Vagrant — demonstração prática executada na VM; documento editado no host
> **Pré-requisito:** Labs 01 a 06 concluídos — Ollama com mistral:7b-instruct-q4_K_M (ou phi3:mini) ativo na VM

```bash
# Confirme o ambiente antes de preencher:
vagrant ssh
ollama list           # modelo deve estar listado
systemctl status ollama   # active (running)
```

---

> **Instruções:** Escolha um dos três cenários disponíveis (A — Saúde, B — Jurídico, C — Financeiro) e preencha todas as seções deste template. O documento deve ter entre 2 e 3 páginas. Não remova as instruções em itálico — elas orientam o revisor. Substitua todos os campos entre colchetes `[ ]` pelo seu conteúdo.

---

**Cenário escolhido:** ☐ A — Saúde   ☐ B — Jurídico   ☐ C — Financeiro

**Organização fictícia:** [nome do cenário conforme o módulo]

**Data de elaboração:** [data]

---

## Seção 1 — Modelo Open Source Recomendado

> *O aluno deve nomear o modelo, a versão (família + instruct vs. base), e justificar com exatamente três critérios técnicos. Critérios vagos ("é bom", "é popular") não são válidos — critérios técnicos referem-se a licença, janela de contexto, hardware mínimo, benchmark documentado ou caso de uso no model card.*

**Modelo recomendado (organização/nome/versão):**
```
[ex: mistralai/Mistral-7B-Instruct-v0.3]
```

**Critério 1 — Licença:**
```
[descreva a licença do modelo e por que ela é adequada ao cenário escolhido
ex: Apache 2.0 — permite uso comercial sem restrições adicionais, adequado ao contexto corporativo]
```

**Critério 2 — Hardware:**
```
[descreva o hardware necessário para o modelo em quantização Q4 e compare com o hardware disponível no cenário
ex: Mistral 7B Q4 exige ~5GB VRAM ou ~8GB RAM para rodar em CPU — compatível com o servidor Dell disponível no Cenário A sem GPU]
```

**Critério 3 — Adequação ao caso de uso:**
```
[cite o caso de uso documentado no model card, benchmark relevante, ou janela de contexto necessária para o cenário
ex: janela de contexto de 32k tokens é suficiente para os contratos de 40 páginas do Cenário B (~15k tokens)]
```

**Alternativa sem GPU (se aplicável):**
```
[se o cenário não tem GPU, qual é a alternativa? ex: Phi-3 Mini Q4 roda em CPU com 8GB RAM]
```

---

## Seção 2 — Arquitetura de Serviço

> *O aluno deve descrever os componentes usando os blocos do Módulo 5. Mínimo obrigatório: servidor de inferência (qual ferramenta), autenticação (quem acessa), logging (o que registrar). Para cenários com dados sensíveis (A e C), a arquitetura deve endereçar o isolamento. Um diagrama ASCII é suficiente — não é necessário um diagrama formal.*

**Diagrama de arquitetura (ASCII ou texto estruturado):**
```
[descreva os componentes e o fluxo de dados
ex:
[Usuário — enfermeiro autenticado]
        |
        ▼
[Gateway de API — autenticação por credencial LDAP do hospital]
        |
        ▼
[Servidor Ollama — Mistral 7B Q4, servidor Dell local]
        |
        ▼
[Base de documentos — prontuários indexados no banco vetorial]
        |
        ▼
[Log de auditoria — timestamp, user_id, hash do prompt, tokens usados]
]
```

**Servidor de inferência:**
```
[qual ferramenta — Ollama, vLLM, TGI, llama.cpp — e por quê esta escolha para o cenário]
```

**Autenticação:**
```
[quem pode acessar o sistema? como o usuário é autenticado? integração com sistema existente?]
```

**Logging e retenção:**
```
[o que registrar: timestamp, user_id, hash do prompt, tokens, latência
por quanto tempo reter? quem tem acesso aos logs?
atenção: se o prompt contém dados pessoais, os logs também contêm — definir política de retenção]
```

**Isolamento de dados (obrigatório para Cenários A e C):**
```
[single-tenant ou multi-tenant? como o contexto de um usuário é isolado do de outro?]
```

---

## Seção 3 — Estimativa de TCO Simplificada

> *O aluno deve calcular dois cenários com premissas explícitas. O break-even é o resultado central. Volume de consultas deve derivar do cenário — não pode ser inventado. Usar `[verificar preços atuais]` quando os preços referenciais não forem conhecidos.*

### Premissas do cálculo

| Campo | Valor |
|:------|:------|
| Volume de consultas por dia | [derivar do cenário — ex: 300 atendimentos × 50 perguntas = 15.000/dia] |
| Tokens médios por consulta | [entrada + saída — ex: 600 tokens] |
| Volume mensal de tokens | [consultas/dia × dias úteis × tokens/consulta] |
| Dias úteis por mês | 22 |

### Cenário A — API Proprietária

| Item | Valor |
|:-----|:------|
| Provedor e modelo | [ex: OpenAI GPT-4o] |
| Custo de entrada (por token) | [verificar preços atuais em openai.com/pricing] |
| Custo de saída (por token) | [verificar preços atuais] |
| **Custo mensal estimado** | [calcular] |

### Cenário B — Open Source Local

| Item | Valor |
|:-----|:------|
| CAPEX do hardware | [conforme o cenário — ex: R$ 30.000 para RTX 4090 + servidor] |
| Amortização (meses) | [ex: 48 meses] |
| CAPEX amortizado por mês | [CAPEX ÷ meses de amortização] |
| Energia por mês | [potência em kW × horas de uso/mês × tarifa local do cenário] |
| Operação (DevOps) por mês | [estimativa em horas × custo/hora] |
| **Custo mensal total** | [somar todos os itens] |

### Break-even

```
Break-even (meses) = CAPEX ÷ (Custo mensal API − Custo mensal open source local)

Break-even = R$ [CAPEX] ÷ (R$ [custo_API] − R$ [custo_local]) = [X] meses
```

**Conclusão do TCO:**
```
[Qual cenário é mais barato no horizonte de [N] anos? O break-even favorece open source ou API?
Se o break-even for > 36 meses, justifique a escolha de open source por critério não-custo (privacidade, LGPD, latência)]
```

---

## Seção 4 — Principais Riscos e Mitigações

> *O aluno deve identificar três riscos específicos para o cenário escolhido — não genéricos. Um dos três deve ser de LGPD com o artigo correto (7, 11 ou 33). A manifestação deve descrever como o risco ocorre neste cenário específico. O custo da mitigação deve estar incluído no TCO.*

### Risco 1

**Nome do risco:**
```
[ex: Alucinação sobre medicação do paciente — Cenário A]
```

**Como se manifesta neste cenário:**
```
[ex: o RAG recupera o prontuário errado em uma busca ambígua (dois pacientes com nomes similares) e o LLM retorna a lista de alergias do paciente incorreto para o enfermeiro]
```

**Mitigação concreta:**
```
[ex: exibir obrigatoriamente o nome do paciente e o número do prontuário junto com cada resposta; o enfermeiro confirma visualmente antes de agir; log de todas as consultas para auditoria]
```

**Custo da mitigação incluído no TCO?** ☐ Sim   ☐ Não (justificar)

---

### Risco 2 — LGPD (obrigatório)

**Artigo da LGPD aplicável:** Art. [7 / 11 / 33]

**Nome do risco:**
```
[ex: Dados de saúde processados sem base legal documentada — Art. 11, LGPD]
```

**Como se manifesta neste cenário:**
```
[ex: o sistema processa prontuários médicos — dados sensíveis sob Art. 11 — sem base legal documentada. A base legal "legítimo interesse" não é válida para dados sensíveis; exige consentimento ou obrigação legal, que não foi mapeada antes do deploy]
```

**Mitigação concreta:**
```
[ex: consultar o DPO do hospital antes do deploy para identificar a base legal adequada; documentar no RIPD (Relatório de Impacto à Proteção de Dados Pessoais); colher o parecer jurídico sobre a resolução CFM aplicável]
```

**Custo da mitigação incluído no TCO?** ☐ Sim   ☐ Não (justificar)

---

### Risco 3

**Nome do risco:**
```
[preencher]
```

**Como se manifesta neste cenário:**
```
[preencher com manifestação específica para o cenário escolhido]
```

**Mitigação concreta:**
```
[preencher]
```

**Custo da mitigação incluído no TCO?** ☐ Sim   ☐ Não (justificar)

---

## Seção 5 — Recomendação Final

> *O aluno deve emitir uma das três recomendações abaixo e sustentar com ao menos três critérios técnicos apresentados nas seções anteriores. A recomendação "depende" sem especificar de quê não é válida.*

**Recomendação:** ☐ Avança   ☐ Pivota   ☐ Não faz

**Se avança — com qual cenário de TCO:**
```
[Cenário A (API) ou Cenário B (open source local), com justificativa]
```

**Se pivota — o que muda:**
```
[ex: avança com open source, mas com Phi-3 Mini em CPU em vez de Mistral 7B com GPU —
reduz o CAPEX de R$ 30.000 para zero e mantém os dados no perímetro do hospital]
```

**Se não faz — por quê:**
```
[ex: o TCO não fecha em 36 meses para o volume de 200 consultas/dia do Cenário B,
e o volume é insuficiente para justificar a infraestrutura; recomendar API com contrato
de DPA explícito com o provedor]
```

**Três critérios técnicos que sustentam a recomendação:**

1. **Critério 1:**
```
[ex: Custo — o break-even de 21 meses favorece open source para o volume de 5.000 consultas/dia]
```

2. **Critério 2:**
```
[ex: LGPD — dados de saúde (Art. 11) não podem trafegar por APIs estrangeiras sem base legal documentada para transferência internacional (Art. 33)]
```

3. **Critério 3:**
```
[ex: Hardware — o servidor Dell disponível suporta Phi-3 Mini Q4 em CPU sem investimento adicional em GPU]
```

---

## Evidência da Demonstração Prática

Cole aqui a resposta gerada pelo modelo durante a etapa de demonstração (Verificação do Ambiente no módulo 7):

```
[cole aqui a resposta do modelo ao prompt do cenário escolhido]
```

**Latência observada (`real` do `time curl`):** `[ex: 8.3s]`

**Tokens consumidos na demonstração:**

| Campo | Valor |
|:------|:------|
| `usage.prompt_tokens` | |
| `usage.completion_tokens` | |
| `usage.total_tokens` | |

**A resposta do modelo foi adequada para o cenário escolhido?** `[ ] Sim  [ ] Não`

Se não foi adequada, o que você mudaria no system prompt para o deploy real?

> Resposta:

---

*Este documento foi produzido como entregável do Módulo 7 — Casos Reais e Projeto Integrador, Curso 1 da Trilha IA Open Source 4Linux.*
