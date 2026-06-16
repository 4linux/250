# Lab 04 — Parâmetros de Inferência: Temperature, Tokens e API

> **Módulo:** 4 — Rodando um LLM: Da Teoria ao Terminal
> **Ambiente:** VM via Vagrant — todos os comandos executados após `vagrant ssh`
> **Duração estimada:** 60–75 minutos

---

## Contexto do Ambiente

Todos os comandos deste lab são executados dentro da VM:

```bash
# No terminal do host:
vagrant ssh

# Confirmar que o ambiente está pronto:
systemctl status ollama                    # active (running)
ollama list                                # mistral:7b-instruct-q4_K_M ou phi3:mini
curl -s http://localhost:11434/api/tags    # JSON com os modelos disponíveis
```

**Modelo em uso neste lab:**

```
[ ] mistral:7b-instruct-q4_K_M   (padrão do curso — host com 12GB+ de RAM)
[ ] phi3:mini                     (fallback — host com menos de 12GB de RAM)
```

---

## Etapa 1 — Inspeção do Ambiente

Cole aqui o output de `ollama show <modelo>`. Preencha a tabela com os valores encontrados:

```
[cole aqui o output do ollama show]
```

| Campo | Valor encontrado |
|:------|:----------------|
| Arquitetura | |
| Número de parâmetros | |
| Quantização | |
| Context window (tokens) | |
| Tamanho em disco | |

---

## Etapa 2 — Experimento de Temperature

**Prompt usado em todas as chamadas:**
> "Complete a frase de forma criativa: Um sistema corporativo sem monitoramento é como..."

### Temperature 0.0

Execute o comando 3 vezes seguidas e registre cada resposta:

| Execução | Resposta gerada |
|:--------:|:---------------|
| 1ª | |
| 2ª | |
| 3ª | |

As três respostas foram iguais? `[ ] Sim  [ ] Não`

### Temperature 0.7

| Execução | Resposta gerada |
|:--------:|:---------------|
| 1ª | |

### Temperature 1.5

| Execução | Resposta gerada |
|:--------:|:---------------|
| 1ª | |

### Análise

**1.** Com temperature 0.0, o que aconteceu ao repetir a chamada três vezes? Por que isso ocorre?

> Resposta:

**2.** Qual das três temperatures você usaria em um sistema de suporte corporativo que precisa de respostas consistentes? Por quê?

> Resposta:

---

## Etapa 3 — Requisição de Chat Completa

Cole aqui o JSON completo retornado pelo curl (output da Etapa 3 do lab):

```json
[cole aqui o output do python3 -m json.tool]
```

Identifique e preencha os campos abaixo:

| Campo no JSON | Valor encontrado | O que representa |
|:-------------|:----------------|:----------------|
| `choices[0].message.content` | *(primeiras palavras)* | Texto da resposta gerada |
| `choices[0].finish_reason` | | Por que a geração parou |
| `usage.prompt_tokens` | | Tokens do system prompt + pergunta |
| `usage.completion_tokens` | | Tokens gerados na resposta |
| `usage.total_tokens` | | Total consumido da janela de contexto |

**O `finish_reason` foi `"stop"` ou `"length"`?**

```
[ ] "stop"   → o modelo chegou a uma conclusão natural dentro do limite
[ ] "length" → o modelo atingiu max_tokens antes de terminar a resposta
```

Se foi `"length"`: o que você mudaria no comando para obter a resposta completa?

> Resposta:

---

## Etapa 4 — Script Python

Cole aqui o output completo do `python3 /home/vagrant/labs/lab_04_chat.py`:

```
[cole aqui o output]
```

Responda:

**1.** O `prompt_tokens` foi igual nas duas chamadas (temperature 0.0 e 1.0)? Por quê?

> Resposta:

**2.** O `completion_tokens` foi diferente entre as duas chamadas? O que isso indica?

> Resposta:

---

## Etapa 5 — Streaming (Opcional)

Ative o streaming e observe o formato Server-Sent Events na saída bruta do terminal.

```bash
curl -s http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mistral:7b-instruct-q4_K_M",
    "messages": [
      {"role": "user", "content": "Explique em 3 frases o que são tokens em LLMs."}
    ],
    "stream": true
  }'
```

### O que observar

Cole abaixo as primeiras 5 linhas da saída (cada `data: {...}` é um fragmento):

```
[cole as primeiras 5 linhas da saída]
```

| Verificação | Resposta |
|:------------|:---------|
| Cada linha começa com `data: `? | sim / não |
| O campo `delta.content` contém pedaços do texto? | sim / não |
| A última linha de dados tem `finish_reason: "stop"`? | sim / não |
| A saída termina com `data: [DONE]`? | sim / não |

**O campo `usage` aparece na resposta de streaming?**

```
[ ] Sim, em algum fragmento
[ ] Não — usage só está disponível em stream: false
```

**O que muda na experiência do usuário final com streaming ativado?**

> Resposta:

---

## Conclusão

**Em uma frase:** para qual tipo de tarefa corporativa você usaria `temperature: 0.0` e para qual usaria `temperature: 0.7`?

> `temperature: 0.0` → tarefas como:
>
> `temperature: 0.7` → tarefas como:

**Qual a diferença prática entre `stream: false` e `stream: true` do ponto de vista do desenvolvedor que integra o modelo?**

> Resposta:

---

*Lab 04 — Módulo 4, Curso 1 da Trilha IA Open Source 4Linux.*
