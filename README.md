# LLMs Open Source: Do Zero ao Seu Primeiro Modelo Corporativo

Repositório do ambiente de laboratório para o curso **250** da [4Linux](https://4linux.com.br).

---

## Pré-requisitos

| Software | Versão mínima | Download |
|---|---|---|
| Vagrant | 2.4.9+ | [developer.hashicorp.com/vagrant](https://developer.hashicorp.com/vagrant/install) |
| VirtualBox | 7.0.x – 7.2.x | [virtualbox.org](https://www.virtualbox.org/wiki/Downloads) |
| RAM do host | 8 GB | — |
| Disco livre | 25 GB | — |

> **Apple Silicon (M1/M2/M3):** VirtualBox não é suportado. Use [UTM](https://mac.getutm.app/) com Ubuntu 24.04 ARM64 e execute o provisionamento manualmente (instruções na seção Alternativas).

> **Windows com Hyper-V ativo:** pode reduzir a performance do VirtualBox em até 40%. Verifique: `systeminfo | findstr /i "hyper-v"` no PowerShell como administrador.

---

## Início Rápido

```bash
git clone <url-deste-repo> && cd 250
vagrant up        # primeira vez: ~15–20 min
vagrant ssh       # acessa a VM
```

Após o provisionamento, dentro da VM:

```bash
bash /home/vagrant/labs/validate_env.sh   # verifica o ambiente
```

---

## Serviços Disponíveis

| Serviço | URL no host | Usuário | Senha |
|---|---|---|---|
| JupyterLab | http://localhost:8888 | — | `llmlab` |
| Ollama API | http://localhost:11434 | — | — |
| Ollama (Docker, Lab 05) | http://localhost:11435 | — | — |
| Open WebUI (Lab 03) | http://localhost:3000 | — | — |

---

## Mapa de Laboratórios

| Lab | Módulo | Título | Entregável |
|---|---|---|---|
| Lab 01 | M1 | Comparando LLMs na Prática | `lab_01_tabela_comparativa.md` |
| Lab 02 | M2 | Matriz de Decisão Corporativa | `lab_02_matriz_decisao.md` |
| Lab 03 | M3 | Exploração de Model Cards | `lab_03_ficha_modelos.md` |
| Lab 04 | M4 | Rodando e Configurando LLMs | `lab_04_parametros.md` + script Python |
| Lab 05 | M5 | Arquitetura com Docker | `lab_05_diagrama_arquitetura.md` |
| Lab 06 | M6 | Análise de TCO | `lab_06_tco.ipynb` |
| Lab 07 | M7 | Projeto Integrador | `lab_07_template_integrador.md` |

Os arquivos ficam em `labs/` no repositório e em `/home/vagrant/labs` dentro da VM (pasta compartilhada — edite no host, execute na VM).

---

## Modelos LLM

O provisionamento baixa automaticamente apenas o `phi3:mini` (~2.3 GB). O modelo padrão do curso (`mistral:7b-instruct-q4_K_M`, ~4.1 GB) é baixado no Lab 03.

| RAM do host | RAM da VM | Modelo | Observação |
|---|---|---|---|
| 8 GB | 4 GB (padrão) | `phi3:mini` | Base do curso |
| 12 GB | 6 GB* | `mistral:7b-instruct-q4_K_M` | Edite `vb.memory = 6144` no Vagrantfile |
| 16 GB+ | 6–8 GB* | `mistral:7b-instruct-q4_K_M` | Ideal |

*Para aumentar a RAM da VM, edite o `Vagrantfile` antes do `vagrant up`:
```ruby
vb.memory = 6144   # 6 GB
```

---

## Comandos Úteis

```bash
vagrant up          # iniciar e provisionar a VM
vagrant ssh         # acessar a VM
vagrant halt        # desligar a VM
vagrant destroy     # remover a VM completamente
vagrant provision   # re-executar o provisionamento (sem recriar)
```

Dentro da VM:

```bash
ollama list                              # modelos disponíveis
ollama pull mistral:7b-instruct-q4_K_M  # Lab 03+ (requer ~12 GB no host)
curl http://localhost:11434/api/tags     # testar API Ollama
systemctl status jupyterlab             # verificar JupyterLab
```

---

## Alternativas

### Apple Silicon (M1/M2/M3)

1. Instale o [UTM](https://mac.getutm.app/) (gratuito, open source)
2. Crie uma VM com Ubuntu 24.04 ARM64 (imagem oficial da Canonical)
3. Dentro da VM, execute manualmente os playbooks Ansible:
   ```bash
   sudo apt install ansible -y
   sudo ansible-playbook provisionamento/ansible/playbook.yml
   ```

### Linux Nativo (Ubuntu/Debian)

Sem VM — execute diretamente no sistema:
```bash
sudo apt install ansible -y
sudo ansible-playbook provisionamento/ansible/playbook.yml
```

---

## Solução de Problemas

**Porta 8888 ou 11434 já em uso no host:**
O Vagrant usa `auto_correct: true` — a porta efetiva aparece no output do `vagrant up`. Verifique qual porta foi atribuída e acesse por ela.

**`vagrant up` travado em "Waiting for machine to boot":**
Verifique se a virtualização está habilitada na BIOS (VT-x / AMD-V). No Windows, desabilite o Hyper-V se ativo.

**Ollama lento (< 2 tok/s):**
Normal em CPU. O `phi3:mini` gera 15–25 tok/s em 4 vCPUs. O `mistral:7b` gera 6–10 tok/s. Aumente `vb.cpus` se tiver mais núcleos disponíveis.
