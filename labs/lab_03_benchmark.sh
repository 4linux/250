#!/usr/bin/env bash
# lab_03_benchmark.sh — Benchmark de desempenho de LLMs via Ollama
# Aula 03 — LLMs Open Source: Do Zero ao Seu Primeiro Modelo Corporativo (4Linux)
#
# Uso:
#   bash lab_03_benchmark.sh              # benchmarka todos os modelos instalados
#   bash lab_03_benchmark.sh phi3:mini    # benchmarka um modelo específico
#   bash lab_03_benchmark.sh phi3:mini mistral  # benchmarka múltiplos modelos
#
# O prompt de referência é neutro e em português — sem dependência de contexto
# de legislação específica, para medir throughput puro de geração.

set -euo pipefail

OLLAMA_URL="${OLLAMA_HOST:-http://localhost:11434}"

PROMPT_BENCH="Explique em exatamente 3 frases curtas e objetivas: o que é aprendizado de máquina e em que ele difere fundamentalmente da programação tradicional baseada em regras explícitas. Responda em português."

print_header() {
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║        Benchmark de LLMs — Aula 03 (4Linux)         ║"
  echo "║  Prompt: 3 frases sobre ML vs programação clássica   ║"
  echo "╚══════════════════════════════════════════════════════╝"
}

print_separator() {
  echo "──────────────────────────────────────────────────────"
}

check_ollama() {
  if ! curl -sf "$OLLAMA_URL/api/tags" > /dev/null 2>&1; then
    echo "ERRO: Ollama não está acessível em $OLLAMA_URL"
    echo "Verifique: systemctl status ollama"
    exit 1
  fi
}

benchmark_model() {
  local model="$1"

  echo ""
  print_separator
  echo "  Modelo: $model"
  print_separator

  local payload
  payload=$(printf '{"model":"%s","prompt":"%s","stream":false}' \
    "$model" \
    "$(echo "$PROMPT_BENCH" | sed 's/"/\\"/g')")

  local result
  result=$(curl -sf "$OLLAMA_URL/api/generate" \
    -H "Content-Type: application/json" \
    -d "$payload" 2>&1) || {
    echo "  ERRO: modelo '$model' não respondeu ou não está instalado."
    echo "  Instale com: ollama pull $model"
    return 1
  }

  if ! echo "$result" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    echo "  ERRO: resposta JSON inválida do Ollama."
    return 1
  fi

  OLLAMA_RESULT="$result" python3 - << 'PYEOF'
import sys, json, os

r = json.loads(os.environ["OLLAMA_RESULT"])

eval_ns    = r.get("eval_duration", 1)
load_ns    = r.get("load_duration", 0)
prompt_ns  = r.get("prompt_eval_duration", 0)
total_ns   = r.get("total_duration", 0)
n_gen      = r.get("eval_count", 0)
n_prompt   = r.get("prompt_eval_count", 0)

eval_s     = eval_ns / 1e9
load_s     = load_ns / 1e9
total_s    = total_ns / 1e9
tps        = n_gen / eval_s if eval_s > 0 else 0

print(f"  Tokens de entrada:   {n_prompt} tok")
print(f"  Tokens gerados:      {n_gen} tok")
print(f"  Tokens/segundo:      {tps:.1f} tok/s  ← anote na ficha do lab")
print(f"  Tempo de geração:    {eval_s:.1f}s")
print(f"  Carga do modelo:     {load_s:.1f}s  (0 = já estava em memória)")
print(f"  Tempo total:         {total_s:.1f}s")
print()
print("  Resposta:")
for line in r.get("response", "").strip().split("\n"):
    print(f"    {line}")
PYEOF
}

list_installed_models() {
  curl -sf "$OLLAMA_URL/api/tags" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
models = [m['name'] for m in data.get('models', [])]
for m in models:
    print(m)
" 2>/dev/null || true
}

main() {
  check_ollama
  print_header

  if [ "$#" -gt 0 ]; then
    local models=("$@")
    for model in "${models[@]}"; do
      benchmark_model "$model" || true
    done
  else
    echo ""
    echo "Detectando modelos instalados em $OLLAMA_URL..."
    mapfile -t models < <(list_installed_models)

    if [ "${#models[@]}" -eq 0 ]; then
      echo "Nenhum modelo instalado. Instale com: ollama pull phi3:mini"
      exit 1
    fi

    echo "Modelos encontrados: ${models[*]}"

    for model in "${models[@]}"; do
      benchmark_model "$model" || true
    done
  fi

  echo ""
  print_separator
  echo "  Benchmark concluído."
  echo "  Registre os valores de tok/s na tabela da ficha do lab."
  print_separator
  echo ""
}

main "$@"