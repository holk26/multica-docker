# 🤖 Agent Worker para Multica

Contenedor Docker con agentes de IA que se conectan automáticamente a tu instancia self-hosted de Multica.

## ¿Qué hace?

- Corre el **daemon de Multica** dentro de un contenedor
- Detecta los **agentes de IA instalados** (Claude, Codex, Kimi, etc.)
- Se conecta a tu **Multica self-hosted** (`space.moonsbow.com`)
- Ejecuta tareas asignadas por el servidor

## 📁 Archivos

| Archivo | Descripción |
|---------|-------------|
| `Dockerfile` | Imagen con Node.js, Python, Git, Docker |
| `entrypoint.sh` | Configura multica e inicia el daemon |
| `README.md` | Esta guía |

## 🚀 Uso

### En Docker Compose local

```bash
docker compose -f docker-compose.local.yml up -d agent-worker
```

### En Dokploy

Agregá el servicio `agent-worker` al docker-compose.yml y deployá.

## 🔧 Variables de entorno

| Variable | Requerida | Descripción | Ejemplo |
|----------|-----------|-------------|---------|
| `MULTICA_SERVER_URL` | ✅ | URL del backend API | `https://space-api.moonsbow.com` |
| `MULTICA_APP_URL` | ✅ | URL del frontend | `https://space.moonsbow.com` |
| `MULTICA_AUTH_TOKEN` | ❌ | Token de autenticación (opcional) | `...` |
| `OPENAI_API_KEY` | ❌ | API Key de OpenAI (para Codex) | `sk-...` |
| `ANTHROPIC_API_KEY` | ❌ | API Key de Anthropic (para Claude) | `sk-ant-...` |
| `GOOGLE_API_KEY` | ❌ | API Key de Google (para Gemini) | `...` |

## 🛠️ Instalar agentes adicionales

El contenedor tiene Node.js y npm. Podés instalar agentes globales:

```bash
# Entrar al contenedor
docker compose exec agent-worker bash

# Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# Instalar Codex
npm install -g @openai/codex

# Instalar Gemini CLI
npm install -g @google/gemini-cli

# Reiniciar el daemon
multica daemon restart
```

## 📋 Agentes soportados por Multica

| Agente | Comando | Instalación |
|--------|---------|-------------|
| Claude Code | `claude` | `npm install -g @anthropic-ai/claude-code` |
| Codex | `codex` | `npm install -g @openai/codex` |
| Gemini | `gemini` | `npm install -g @google/gemini-cli` |
| GitHub Copilot | `copilot` | `gh extension install github/copilot` |
| Kimi | `kimi` | *Instalación manual* |
| Kiro CLI | `kiro` | *Instalación manual* |
| OpenCode | `opencode` | *Instalación manual* |
| OpenClaw | `openclaw` | *Instalación manual* |
| Pi | `pi` | *Instalación manual* |
| Hermes | `hermes` | *Instalación manual* |

## 🔄 Reconectar agentes

Si instalás nuevos agentes, ejecutá:

```bash
multica daemon restart
```

El daemon detectará los nuevos agentes automáticamente.

## 📚 Documentación

- [Multica Self-Host Guide](https://multica.ai/docs)
- [Multica GitHub](https://github.com/multica-ai/multica)
