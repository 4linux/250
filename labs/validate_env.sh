#!/bin/bash
# Validação do ambiente LLM Lab — Curso 4Linux: LLMs Open Source
# Execute dentro da VM após vagrant ssh:
#   bash /home/vagrant/labs/validate_env.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
INFOS=0

ok()   { echo -e "  ${GREEN}[OK]${NC}   $1"; }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; ERRORS=$((ERRORS + 1)); }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
info() { echo -e "  ${BLUE}[INFO]${NC} $1"; INFOS=$((INFOS + 1)); }

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Validação do Ambiente — LLM Lab (4Linux)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Ollama ────────────────────────────────────────────────────────────────────
echo ""
echo "[ Ollama ]"

if systemctl is-active --quiet ollama; then
    ok "Serviço ollama: ativo"
else
    fail "Serviço ollama: inativo  →  sudo systemctl start ollama"
fi

if curl -sf http://localhost:11434/api/tags > /dev/null 2>&1; then
    ok "API Ollama respondendo em :11434"
else
    fail "API Ollama não responde em :11434"
fi

if ollama list 2>/dev/null | grep -q "phi3:mini"; then
    ok "Modelo phi3:mini disponível (fallback do curso)"
else
    warn "phi3:mini não encontrado  →  ollama pull phi3:mini"
fi

if ollama list 2>/dev/null | grep -q "mistral"; then
    ok "Modelo mistral:7b-instruct disponível (padrão do curso, Lab 03+)"
else
    info "mistral:7b ainda não baixado — será feito no Lab 03:"
    info "  ollama pull mistral:7b-instruct-q4_K_M"
fi

# ── Docker ────────────────────────────────────────────────────────────────────
echo ""
echo "[ Docker ]"

if systemctl is-active --quiet docker; then
    ok "Serviço docker: ativo"
else
    fail "Serviço docker: inativo  →  sudo systemctl start docker"
fi

if docker compose version > /dev/null 2>&1; then
    VER=$(docker compose version --short 2>/dev/null || echo "v2+")
    ok "Docker Compose v2: $VER"
else
    fail "Docker Compose v2: não encontrado"
fi

if id -nG vagrant 2>/dev/null | grep -qw docker; then
    ok "Usuário vagrant: grupo docker OK"
else
    warn "vagrant não está no grupo docker — pode precisar de sudo"
fi

# ── Python e bibliotecas ──────────────────────────────────────────────────────
echo ""
echo "[ Python / venv ]"

VENV_PYTHON="/home/vagrant/venv/bin/python3"
if [ -f "$VENV_PYTHON" ]; then
    PY_VER=$($VENV_PYTHON --version 2>&1)
    ok "venv em /home/vagrant/venv ($PY_VER)"
else
    fail "venv não encontrado em /home/vagrant/venv"
    VENV_PYTHON="python3"
fi

for lib in requests httpx pandas matplotlib jupyterlab; do
    if $VENV_PYTHON -c "import $lib" 2>/dev/null; then
        ok "  $lib: instalado"
    else
        fail "  $lib: não encontrado no venv"
    fi
done

# ── JupyterLab ────────────────────────────────────────────────────────────────
echo ""
echo "[ JupyterLab ]"

if systemctl is-active --quiet jupyterlab; then
    ok "Serviço jupyterlab: ativo em :8888"
else
    fail "Serviço jupyterlab: inativo  →  sudo systemctl start jupyterlab"
fi

HTTP_CODE=$(curl -so /dev/null -w "%{http_code}" http://localhost:8888/api 2>/dev/null)
if [[ "$HTTP_CODE" == "200" || "$HTTP_CODE" == "401" ]]; then
    ok "JupyterLab API respondendo (HTTP $HTTP_CODE)"
else
    fail "JupyterLab não responde em :8888 (HTTP $HTTP_CODE)"
fi

# ── Pasta labs ────────────────────────────────────────────────────────────────
echo ""
echo "[ Pasta /home/vagrant/labs ]"

if [ -d /home/vagrant/labs ]; then
    ok "Pasta existe e está montada"
    MD_COUNT=$(find /home/vagrant/labs -maxdepth 1 -name "lab_0*.md" | wc -l)
    ok "Arquivos de lab encontrados: $MD_COUNT arquivos lab_0*.md"
else
    fail "Pasta /home/vagrant/labs não encontrada (sincronização Vagrant falhou?)"
fi

if [ -f /home/vagrant/labs/lab_04_chat.py ]; then
    ok "lab_04_chat.py presente"
else
    warn "lab_04_chat.py não encontrado"
fi

if [ -f /home/vagrant/labs/lab_05_stack/docker-compose.yml ]; then
    ok "lab_05_stack/docker-compose.yml presente"
else
    warn "lab_05_stack/docker-compose.yml não encontrado"
fi

if [ -f /home/vagrant/labs/lab_06_tco.ipynb ]; then
    ok "lab_06_tco.ipynb presente"
else
    warn "lab_06_tco.ipynb não encontrado"
fi

# ── Resultado ─────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo -e "  ${GREEN}✓ Ambiente pronto — $ERRORS erros, $WARNINGS avisos.${NC}"
    echo ""
    echo "  Acesso ao JupyterLab → http://localhost:8888  (senha: llmlab)"
    echo "  Acesso à API Ollama  → http://localhost:11434"
    echo ""
    echo "  Lab 03+: ollama pull mistral:7b-instruct-q4_K_M"
    echo "  Lab 04:  python3 /home/vagrant/labs/lab_04_chat.py"
    echo "  Lab 05:  cd /home/vagrant/labs/lab_05_stack && docker compose up -d"
else
    echo -e "  ${RED}✗ $ERRORS erro(s) encontrado(s). Corrija antes de iniciar os labs.${NC}"
    echo -e "  ${YELLOW}  $WARNINGS aviso(s) — não bloqueantes mas verifique.${NC}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
