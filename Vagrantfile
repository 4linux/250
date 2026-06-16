# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# LLM Lab — Ambiente de laboratório para o curso:
# "LLMs Open Source: Do Zero ao Seu Primeiro Modelo Corporativo" (4Linux)
#
# Box:      bento/debian-12 (Debian 12 Bookworm — estável com Guest Additions)
# Serviços: Ollama :11434 | JupyterLab :8888 | Docker Engine + Compose v2
#
# Uso rápido:
#   vagrant up        — inicia e provisiona a VM (primeira vez: ~15-20 min)
#   vagrant ssh       — acesso ao terminal da VM
#   vagrant halt      — desliga sem destruir
#   vagrant reload    — reinicia (útil após alterar Vagrantfile)
#   vagrant destroy   — remove a VM completamente
#   vagrant provision — re-executa o provisionamento (sem recriar a VM)
#
# Após o provisionamento:
#   JupyterLab → http://localhost:8888  (senha: llmlab)
#   Ollama API → http://localhost:11434
#   Validação  → vagrant ssh -c "bash /home/vagrant/labs/validate_env.sh"

Vagrant.configure("2") do |config|

  # ── Box base ───────────────────────────────────────────────────────────────
  config.vm.box      = "bento/debian-12"
  config.vm.hostname = "llm-lab"

  # ── Rede (port forwarding) ─────────────────────────────────────────────────
  # JupyterLab — acesse no browser do host: http://localhost:8888
  config.vm.network "forwarded_port",
    guest: 8888, host: 8888, host_ip: "127.0.0.1", auto_correct: true

  # Ollama API (serviço systemd) — curl http://localhost:11434/api/tags
  config.vm.network "forwarded_port",
    guest: 11434, host: 11434, host_ip: "127.0.0.1", auto_correct: true

  # Ollama em container Docker (Lab 05) — porta alternativa para não colidir
  config.vm.network "forwarded_port",
    guest: 11435, host: 11435, host_ip: "127.0.0.1", auto_correct: true

  # Open WebUI (Lab 03) — interface gráfica para o Ollama
  config.vm.network "forwarded_port",
    guest: 3000, host: 3000, host_ip: "127.0.0.1", auto_correct: true

  # ── Pasta compartilhada ────────────────────────────────────────────────────
  # "./labs" = subdiretório labs/ na raiz deste repositório.
  # O aluno edita arquivos no host (VS Code, etc.) e executa comandos na VM.
  config.vm.synced_folder "./labs", "/home/vagrant/labs",
    owner: "vagrant", group: "vagrant",
    mount_options: ["dmode=775", "fmode=664"]

  # ── VirtualBox ────────────────────────────────────────────────────────────
  config.vm.provider "virtualbox" do |vb|
    vb.name   = "llm-lab"
    vb.memory = 4096   # 4 GB — suficiente para phi3:mini
                       # Para mistral:7b, edite para 6144 (requer ~12 GB no host)
    vb.cpus   = 4
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  # ── Provisionamento via Ansible (ansible_local) ────────────────────────────
  # ansible_local: Ansible é instalado DENTRO da VM via apt.
  # O host não precisa ter Ansible instalado — apenas Vagrant + VirtualBox.
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook           = "provisionamento/ansible/playbook.yml"
    ansible.install            = true
    ansible.install_mode       = :default
    ansible.compatibility_mode = "2.0"
    ansible.verbose            = false
  end

end
