#!/usr/bin/env python3
"""
Lab 04 — Chamadas de chat via API Ollama (endpoint OpenAI-compatível).

Execute dentro da VM:
    python3 /home/vagrant/labs/lab_04_chat.py

Cole o output completo na seção "Etapa 4 — Script Python" do lab_04_parametros.md.
"""

import sys
import requests

BASE_URL = "http://localhost:11434/v1/chat/completions"

# Altere para "phi3:mini" se não tiver o Mistral baixado
MODEL = "mistral:7b-instruct-q4_K_M"

SYSTEM = "Você é um assistente técnico objetivo. Responda sempre em português, em no máximo 2 frases claras."


def chat(
    mensagem: str,
    system: str = SYSTEM,
    temperature: float = 0.7,
    max_tokens: int = 200,
) -> dict:
    """Envia uma mensagem com system prompt via endpoint OpenAI-compatível do Ollama."""
    payload = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user",   "content": mensagem},
        ],
        "temperature": temperature,
        "max_tokens": max_tokens,
        "stream": False,
    }
    try:
        response = requests.post(BASE_URL, json=payload, timeout=120)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.ConnectionError:
        print("[ERRO] Ollama não está acessível em localhost:11434")
        print("       Verifique: systemctl status ollama")
        sys.exit(1)
    except requests.exceptions.HTTPError as e:
        print(f"[ERRO] HTTP {e.response.status_code}: {e.response.text}")
        sys.exit(1)


def main():
    pergunta = "Resuma o que é um LLM em exatamente 2 frases."

    print("=" * 60)
    print(f"Modelo  : {MODEL}")
    print(f"Pergunta: {pergunta}")
    print("=" * 60)

    for temperatura in [0.0, 1.0]:
        resultado = chat(pergunta, temperature=temperatura)

        resposta      = resultado["choices"][0]["message"]["content"]
        finish_reason = resultado["choices"][0]["finish_reason"]
        prompt_tokens = resultado["usage"]["prompt_tokens"]
        compl_tokens  = resultado["usage"]["completion_tokens"]
        total_tokens  = resultado["usage"]["total_tokens"]

        print(f"\n--- temperature {temperatura} ---")
        print(f"Resposta          : {resposta.strip()}")
        print(f"finish_reason     : {finish_reason}")
        print(f"prompt_tokens     : {prompt_tokens}")
        print(f"completion_tokens : {compl_tokens}")
        print(f"total_tokens      : {total_tokens}")


if __name__ == "__main__":
    main()
