# Lab 01 — Comparando LLMs na Prática: Três Contextos, Mesmo Prompt

> **Módulo:** 1 — O Que É um LLM de Verdade (Sem Mistério)
> **Ambiente:** VM local via Vagrant (`vagrant up` → `vagrant ssh`)
> **Duração estimada:** 45–60 minutos

---

## Contexto do Ambiente

Este lab é executado na VM do curso. Antes de começar:

```bash
# No terminal do host, dentro do diretório do curso:
vagrant up
vagrant ssh

# Dentro da VM — confirmar que o Ollama está pronto:
systemctl status ollama
ollama list              # deve mostrar phi3:mini
```

A pasta `labs/` está sincronizada com a VM em `/home/vagrant/labs/`. Você pode preencher este arquivo no editor do host enquanto executa os comandos na VM.

---

## O Prompt

Execute o texto abaixo **identicamente** nos três ambientes — sem modificar nada:

```
Você é um consultor de TI. Explique em até 3 parágrafos:
o que é um LLM, por que ele pode inventar informações
e qual o impacto disso em aplicações corporativas críticas
como saúde e jurídico.
```

---

## Tabela Comparativa

| Critério | ChatGPT | HF Inference API | Ollama (VM local) |
|:---------|:-------:|:----------------:|:-----------------:|
| **Resposta gerada** (resuma em 2–3 linhas) | | | |
| **Latência observada** (do envio até fim da geração) | | | |
| **Onde o processamento ocorreu** | Servidores OpenAI — EUA | Servidores Hugging Face | Minha VM — minha máquina |
| **O prompt saiu da minha rede?** | Sim | Sim | Não |
| **O modelo é open source?** | Não | Sim | Sim |
| **Usável com prontuários médicos sem análise jurídica?** | Não — justifique abaixo | Não — justifique abaixo | Depende — justifique abaixo |
| **Observações livres** | | | |

---

## Análise

Responda após preencher a tabela:

**1.** Por que a mesma pergunta pode gerar respostas diferentes nos três ambientes, mesmo que o texto enviado seja idêntico?

> Resposta:

---

**2.** Na Etapa 2, o modelo usado era open source (pesos públicos). Na Etapa 3, também era open source. Do ponto de vista de privacidade de dados, qual é a diferença entre as duas etapas? O que muda?

> Resposta:

---

**3.** Se um hospital precisasse processar notas de prontuários com um LLM, qual dos três ambientes seria o único viável sem violar o Art. 11 da LGPD? Justifique citando onde os dados ficam em cada cenário.

> Resposta:

---

<details>
<summary>Gabarito orientativo — abra somente após preencher</summary>

**Pergunta 1:**
Cada ambiente usa um modelo diferente (GPT-4 ou similar, Mistral 7B, Phi-3 Mini), com dados de treinamento, parâmetros e configurações de sistema distintos. Mesmo com o prompt idêntico, as distribuições de probabilidade dos tokens gerados são diferentes em cada modelo — o que explica variações de tom, estrutura, extensão e até conteúdo factual. Temperatura padrão diferente entre provedores também contribui.

**Pergunta 2:**
Na Etapa 2, o modelo é open source mas o **processamento** ocorreu nos servidores do Hugging Face — os dados do prompt saíram da rede. Na Etapa 3, o modelo também é open source e o processamento ocorreu **dentro da VM, na máquina do aluno** — os dados nunca saíram da rede local. A distinção crítica não é se o modelo é open source ou proprietário: é **onde o dado é processado**. Um modelo open source hospedado em nuvem de terceiro tem o mesmo problema de privacidade que uma API proprietária.

**Pergunta 3:**
Apenas o Ollama na VM local (Etapa 3). Dados de saúde são dados sensíveis sob o Art. 11 da LGPD e exigem base legal mais estrita para tratamento. Enviá-los para servidores externos — sejam da OpenAI (EUA) ou do Hugging Face — ativa também o Art. 33 (transferência internacional de dados pessoais), que exige mecanismos adicionais de conformidade. O único ambiente que elimina esses riscos é o processamento local, onde o dado não sai da rede da organização.

</details>

---

*Lab 01 — Módulo 1, Curso 1 da Trilha IA Open Source 4Linux.*
