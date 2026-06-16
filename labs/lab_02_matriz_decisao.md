# Lab 02 — Matriz de Decisão: Open Source vs. API Proprietária

> **Módulo:** 2 — Open Source vs. Proprietário: Uma Decisão de Negócio
> **Ambiente:** VM local via Vagrant — edição no host, atividade inicial na VM
> **Duração estimada:** 45–60 minutos

---

## Contexto do Ambiente

A VM deve estar em execução (continuidade do Lab 01):

```bash
# No terminal do host:
vagrant ssh
systemctl status ollama   # deve estar active (running)
```

Preencha este arquivo no editor do host — a pasta `labs/` é sincronizada automaticamente com a VM em `/home/vagrant/labs/`.

---

## Instruções

Para cada cenário, avalie os 5 critérios usando a escala abaixo. Registre o raciocínio na coluna "Justificativa" (1 a 3 frases). Na linha **Recomendação**, indique: `open source local`, `API proprietária` ou `híbrido` — e justifique em uma frase. Se escolher híbrido, especifique qual parte do processamento vai para cada ambiente.

**Escala de impacto:**
- **Crítico** — determina sozinho a decisão
- **Alto** — peso significativo na decisão
- **Médio** — relevante mas não determinante
- **Baixo** — pouco impacto na escolha

---

## Cenário A — Clínica de Saúde Ocupacional

> Uma rede de clínicas com 15 unidades quer usar IA para gerar rascunhos de laudos médicos a partir de anotações dos médicos. Os dados incluem nome, CPF, diagnósticos e histórico de saúde dos pacientes. Volume estimado: 500 laudos/dia. Time de TI: 2 pessoas, sem experiência em infraestrutura de modelos.

| Critério | Impacto | Justificativa |
|:---------|:-------:|:--------------|
| 1. Privacidade dos dados | | |
| 2. Custo de escala | | |
| 3. Controle de versão | | |
| 4. Latência | | |
| 5. Compliance regulatório | | |
| **Recomendação** | | |

---

## Cenário B — E-commerce de Médio Porte

> Uma loja online com 800.000 clientes ativos quer usar IA para personalizar descrições de produtos e responder dúvidas no chat. Dados processados: comportamento de navegação e histórico de pedidos — sem dados de saúde ou financeiros. Volume estimado: 2 milhões de tokens/dia. Time de engenharia: 8 pessoas com experiência em cloud.

| Critério | Impacto | Justificativa |
|:---------|:-------:|:--------------|
| 1. Privacidade dos dados | | |
| 2. Custo de escala | | |
| 3. Controle de versão | | |
| 4. Latência | | |
| 5. Compliance regulatório | | |
| **Recomendação** | | |

---

## Cenário C — Escritório de Advocacia Empresarial

> Um escritório com 30 advogados quer automatizar a revisão inicial de contratos societários e de M&A. Os documentos são altamente confidenciais e protegidos por sigilo profissional (OAB). Volume: 20–50 contratos/dia. Orçamento de TI limitado, mas confidencialidade é prioridade máxima.

| Critério | Impacto | Justificativa |
|:---------|:-------:|:--------------|
| 1. Privacidade dos dados | | |
| 2. Custo de escala | | |
| 3. Controle de versão | | |
| 4. Latência | | |
| 5. Compliance regulatório | | |
| **Recomendação** | | |

---

## Reflexão Final

Após preencher os três cenários, responda:

**1.** Em qual dos três cenários a decisão foi mais fácil de justificar? Por quê?

> Resposta:

**2.** O Cenário B é o único onde `API proprietária` pode ser uma resposta defensável. Quais condições precisariam mudar no cenário para que a recomendação mudasse para `open source local`?

> Resposta:

**3.** Na atividade inicial do lab, você usou o Ollama para perguntar sobre riscos jurídicos de LGPD. O dado que você enviou (o prompt) ficou na sua VM. Se você tivesse feito a mesma pergunta no ChatGPT incluindo dados reais de pacientes, o que teria acontecido do ponto de vista do Art. 33 da LGPD?

> Resposta:

---

<details>
<summary>Gabarito de referência — abra somente após preencher</summary>

### Cenário A — Saúde

- **Privacidade:** Crítico — dados de saúde são dados sensíveis (LGPD Art. 11). Qualquer envio para API externa exige consentimento específico do titular e DPA robusto — que raramente cobre o nível de detalhe clínico de um laudo.
- **Custo:** Médio — 500 laudos/dia é volume moderado; o custo de API pode ser gerenciável, mas não é o fator determinante aqui.
- **Controle de versão:** Alto — laudos têm implicação clínica direta; o comportamento do modelo não pode mudar silenciosamente entre versões.
- **Latência:** Baixo — geração de rascunho de laudo não exige resposta em milissegundos.
- **Compliance:** Crítico — CFM + LGPD Art. 11 + sigilo médico. APIs externas sem DPA aprovado pela ANPD são juridicamente inviáveis.
- **Recomendação:** `open source local` — a combinação de dados sensíveis e compliance regulatório torna a API proprietária juridicamente arriscada mesmo com DPA. O time de TI limitado é o único obstáculo real, superável com um modelo quantizado menor (como o `phi3:mini` já em uso no curso) e suporte especializado externo.

### Cenário B — E-commerce

- **Privacidade:** Médio — histórico de pedidos é dado pessoal (LGPD Art. 7), mas não sensível; DPA padrão de provedores como OpenAI cobre esse nível.
- **Custo:** Alto — 2M tokens/dia × 30 dias = 60M tokens/mês. Calcular break-even com o provedor específico; em 12-18 meses a infraestrutura própria pode se tornar mais econômica.
- **Controle de versão:** Baixo — personalização de produto tolera variações de comportamento entre versões do modelo.
- **Latência:** Alto para chat em tempo real; Baixo para geração de descrições em batch.
- **Compliance:** Baixo — sem regulação setorial específica além da LGPD geral, que é satisfeita com DPA.
- **Recomendação:** `API proprietária` no curto prazo, com reavaliação de break-even em 12 meses. Com crescimento de volume, `open source local` ou cloud dedicada passa a ser mais econômica.

### Cenário C — Advocacia

- **Privacidade:** Crítico — documentos M&A e societários têm sigilo profissional (Estatuto da OAB). Envio para API externa é incompatível com as obrigações deontológicas do advogado sem consentimento explícito de cada cliente.
- **Custo:** Baixo — 20-50 contratos/dia é volume pequeno; custo de API seria baixo, mas não é o critério relevante aqui.
- **Controle de versão:** Alto — revisão jurídica exige comportamento auditável e rastreável.
- **Latência:** Baixo — revisão de contrato não exige tempo real.
- **Compliance:** Crítico — sigilo profissional do Estatuto da OAB é determinante e não depende de DPA: o próprio ato de transmitir o documento a um terceiro pode configurar violação.
- **Recomendação:** `open source local` — o orçamento limitado é o obstáculo prático, mas o risco jurídico de API proprietária com documentos de clientes é inaceitável. Um modelo quantizado em CPU (como o `phi3:mini`) pode ser suficiente para o volume, com custo de hardware acessível.

### Reflexão — Pergunta 3

Ao enviar dados reais de pacientes para o ChatGPT, o Art. 33 da LGPD seria ativado: transferência internacional de dados pessoais para os EUA. Isso exige que o país destinatário ofereça proteção adequada reconhecida pela ANPD — o que ainda não foi formalizado entre Brasil e EUA — ou que haja instrumento contratual específico (cláusulas contratuais padrão aprovadas pela ANPD) entre o hospital e a OpenAI. Na prática, isso raramente está em vigor. O processamento local via Ollama elimina completamente esse vetor de risco.

</details>

---

*Lab 02 — Módulo 2, Curso 1 da Trilha IA Open Source 4Linux.*
