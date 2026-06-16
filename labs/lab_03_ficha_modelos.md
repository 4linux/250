# Lab 03 — Ficha Comparativa de Modelos

> **Módulo:** 3 — O Ecossistema Open Source: Quem São os Jogadores
> **Ambiente:** Browser do host (HF Hub) + VM via Vagrant (Ollama + Open WebUI)
> **Duração estimada:** 90–120 minutos

---

## Contexto do Ambiente

A VM deve estar em execução (continuidade dos labs anteriores):

```bash
# No terminal do host:
vagrant ssh
systemctl status ollama   # deve estar active (running)
ollama list               # deve listar phi3:mini (instalado na Aula 1)
```

| Etapa | Onde executar |
|:------|:--------------|
| 1–3: HF Hub e model cards | Browser do host |
| 4–6: Testes com Ollama e benchmark | Terminal da VM (vagrant ssh) |
| 7: Open WebUI | Terminal da VM + browser do host |
| Preenchimento desta ficha | Editor do host (pasta labs/ é sincronizada) |

---

## Parte 1 — Exploração no Hugging Face Hub

### Filtros Aplicados

Registre o número de modelos em cada etapa de filtragem:

| Filtro aplicado | Nº de modelos resultantes |
|:----------------|:--------------------------|
| Sem filtro (página inicial) | |
| Task → Text Generation | |
| + License → apache-2.0 | |
| + Libraries → Transformers | |

---

## Parte 2 — Ficha do Modelo 1

**Nome completo (organização/nome):**

```
[preencher — ex: mistralai/Mistral-7B-Instruct-v0.3]
```

| Campo | Valor |
|:------|:------|
| Tamanho em parâmetros | |
| Organização responsável | |
| Licença | |
| Uso comercial permitido? | |
| Hardware mínimo estimado (Q4_K_M) | |
| Janela de contexto (tokens) | |
| Caso de uso documentado no model card | |
| Data da última atualização | |
| Suporte declarado a português? | |
| Benchmark de destaque (nome + score) | |

**Limitações ou riscos declarados no model card:**

> (Copie ou resuma o conteúdo da seção Bias, Risks, Limitations)

---

## Parte 3 — Ficha do Modelo 2

**Nome completo (organização/nome):**

```
[preencher — ex: Qwen/Qwen2-7B-Instruct]
```

| Campo | Valor |
|:------|:------|
| Tamanho em parâmetros | |
| Organização responsável | |
| Licença | |
| Uso comercial permitido? | |
| Hardware mínimo estimado (Q4_K_M) | |
| Janela de contexto (tokens) | |
| Caso de uso documentado no model card | |
| Data da última atualização | |
| Suporte declarado a português? | |
| Benchmark de destaque (nome + score) | |

**Limitações ou riscos declarados no model card:**

> (Copie ou resuma o conteúdo da seção Bias, Risks, Limitations)

---

## Parte 4 — Testes com Ollama (Prompt Padronizado)

**Prompt usado em todos os modelos:**

```text
Você é um assistente corporativo de RH. Responda de forma objetiva e em português:
Um funcionário com 3 anos de empresa quer tirar 15 dias de férias em janeiro.
Quais são os requisitos mínimos para isso e ele perde o adicional constitucional
se não tirar os 30 dias corridos?
```

### Resultados por Família

Para cada modelo testado, registre: citou a CLT? Mencionou o adicional de 1/3? A resposta foi precisa ou genérica?

**llama3.2:3b — LLaMA 3:**

```bash
# Comando executado:
ollama run llama3.2:3b "<prompt acima>"
```

| Critério | Observado |
|:---------|:----------|
| Citou a CLT? | sim / não |
| Mencionou adicional de 1/3? | sim / não |
| Precisão geral | alta / média / baixa |
| Resposta em PT-BR natural? | sim / parcialmente / não |

> Resumo da resposta (2–3 frases):

---

**phi3:mini — Phi-3 (baseline):**

```bash
ollama run phi3:mini "<prompt acima>"
```

| Critério | Observado |
|:---------|:----------|
| Citou a CLT? | sim / não |
| Mencionou adicional de 1/3? | sim / não |
| Precisão geral | alta / média / baixa |
| Resposta em PT-BR natural? | sim / parcialmente / não |

> Resumo da resposta (2–3 frases):

---

**qwen2.5:3b — Qwen:**

```bash
ollama pull qwen2.5:3b
ollama run qwen2.5:3b "<prompt acima>"
```

| Critério | Observado |
|:---------|:----------|
| Citou a CLT? | sim / não |
| Mencionou adicional de 1/3? | sim / não |
| Precisão geral | alta / média / baixa |
| Resposta em PT-BR natural? | sim / parcialmente / não |

> Resumo da resposta (2–3 frases):

---

**gemma2:2b — Gemma:**

```bash
ollama pull gemma2:2b
ollama run gemma2:2b "<prompt acima>"
```

| Critério | Observado |
|:---------|:----------|
| Citou a CLT? | sim / não |
| Mencionou adicional de 1/3? | sim / não |
| Precisão geral | alta / média / baixa |
| Resposta em PT-BR natural? | sim / parcialmente / não |

> Resumo da resposta (2–3 frases):

---

**mistral:latest — Mistral (opcional — ~4.1GB RAM):**

```bash
ollama pull mistral
ollama run mistral "<prompt acima>"
```

| Critério | Observado |
|:---------|:----------|
| Citou a CLT? | sim / não |
| Mencionou adicional de 1/3? | sim / não |
| Precisão geral | alta / média / baixa |
| Resposta em PT-BR natural? | sim / parcialmente / não |

> Resumo da resposta (2–3 frases):

---

## Parte 5 — Benchmark de Desempenho

Execute o script de benchmark para cada modelo instalado:

```bash
bash /home/vagrant/labs/lab_03_benchmark.sh phi3:mini
bash /home/vagrant/labs/lab_03_benchmark.sh llama3.2:3b
bash /home/vagrant/labs/lab_03_benchmark.sh qwen2.5:3b
bash /home/vagrant/labs/lab_03_benchmark.sh gemma2:2b
```

### Tabela de Resultados

| Modelo | Tokens gerados | Tokens/segundo | Tempo geração | Carga (1ª vez) |
|:-------|:---------------|:---------------|:--------------|:---------------|
| phi3:mini | | | | |
| llama3.2:3b | | | | |
| qwen2.5:3b | | | | |
| gemma2:2b | | | | |
| mistral:latest | | | | |

**Observações sobre o benchmark:**

> (O que surpreendeu? Qual modelo foi mais rápido? A velocidade correspondeu à expectativa pelo tamanho do modelo?)

---

## Parte 6 — Open WebUI

### Instalação

```bash
# Dentro da VM (vagrant ssh):
docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

### Confirmação

| Verificação | Resultado |
|:------------|:----------|
| Container rodando? (`docker ps`) | sim / não |
| Interface acessível em http://localhost:3000? | sim / não |
| Modelos do Ollama aparecem no seletor? | sim / não |
| Prompt padronizado enviado via interface? | sim / não |

**Modelo testado no Open WebUI:**

> [nome do modelo]

**Diferença percebida vs. terminal:**

> (A interface mudou a experiência? O que ficou mais fácil? O que ficou menos visível?)

---

## Parte 7 — Parecer Final: Qual Modelo para o Assistente de RH?

> **Contexto:** O assistente responde perguntas de funcionários sobre benefícios, férias, políticas internas e processos de RH. Os dados processados podem conter informações pessoais (nome, cargo, situação contratual). O sistema vai rodar em servidor corporativo interno. O time de TI tem capacidade de operar infraestrutura básica de servidor Linux.

**Modelo escolhido:**

```
[nome completo do modelo]
```

**Justificativa com três critérios técnicos explícitos:**

> Critério 1 — Licença:
>
> Critério 2 — Qualidade em PT-BR / precisão no domínio (com base nos testes):
>
> Critério 3 — Hardware / desempenho (com base no benchmark):

**O que o model card indica sobre limitações relevantes para este caso?**

> (Mencione ao menos uma limitação declarada no model card que impacta o uso como assistente de RH corporativo no Brasil.)

**O que você monitoraria em produção para validar a qualidade do modelo escolhido?**

> (ex: revisão humana das respostas sobre legislação? filtro de conteúdo? log de prompts para auditoria?)

---

*Lab 03 — Módulo 3, Curso 1 da Trilha IA Open Source 4Linux.*
