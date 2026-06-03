# 🧠 Kimi + Multica Agent Worker

Contenedor Docker con **Kimi CLI** (Moonshot AI) + **demonio de Multica**.

Ideal para tener un **entorno de ejecución de código en la nube siempre disponible**, donde podés interactuar con Kimi interactivamente o dejarlo corriendo como agente autónomo conectado a tu instancia de Multica.

---

## 🏗️ Qué incluye

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| **Kimi CLI** | Latest (`pip install kimi-cli`) | Agente de IA de Moonshot para coding |
| **Multica CLI** | Latest (`curl multica.ai/install.sh`) | Conexión a tu servidor Multica self-hosted |
| **Python** | 3.13+ | Runtime principal de Kimi |
| **uv** | Latest | Package manager ultrarrápido (Astral) |
| **Node.js + npm** | Latest | Proyectos JS/TS |
| **Docker client** | Latest | Kimi puede lanzar contenedores |
| **Git, Go, Rust, Ruby** | Latest | Toolchain completa |

---

## 🚀 Uso rápido

### 1. Levantar el contenedor

```bash
# Producción (con Dokploy o docker-compose.yml)
docker compose up -d kimi-worker

# Local
docker compose -f docker-compose.local.yml up -d kimi-worker
```

### 2. Ver logs

```bash
docker compose logs -f kimi-worker
```

### 3. Entrar al contenedor y usar Kimi

```bash
docker exec -it multica-kimi-worker bash

# Dentro del contenedor:
kimi                    # Iniciar Kimi interactivo
kimi --version          # Ver versión
kimi login              # Login manual (si no hay API key)
```

### 4. Montar tu proyecto local

Editá `docker-compose.yml` y agregá un bind mount:

```yaml
kimi-worker:
  volumes:
    - ./mi-proyecto:/workspace/projects/mi-proyecto
```

---

## ⚙️ Variables de entorno

| Variable | Requerida | Descripción |
|----------|-----------|-------------|
| `KIMI_API_KEY` | **Sí** | API Key de Moonshot AI ([obtener](https://platform.moonshot.cn/)) |
| `MULTICA_SERVER_URL` | No | URL del API de tu Multica (ej: `https://api.tudominio.com`) |
| `MULTICA_APP_URL` | No | URL del frontend de tu Multica (ej: `https://app.tudominio.com`) |
| `MULTICA_AUTH_TOKEN` | No | Token de autenticación de Multica (opcional) |
| `OPENAI_API_KEY` | No | API Key de OpenAI (opcional) |
| `ANTHROPIC_API_KEY` | No | API Key de Anthropic (opcional) |

---

## 📁 Volúmenes persistentes

| Volumen | Ruta en contenedor | Contenido |
|---------|-------------------|-----------|
| `kimi_workspaces` | `/workspace` | Proyectos y archivos de trabajo |
| `kimi_config` | `/root/.config` | Configuraciones de Kimi y Multica |
| `kimi_cache` | `/root/.cache` | Cache de modelos y dependencias |

---

## 🔗 Integración con Multica

Cuando configurás `MULTICA_SERVER_URL` y `MULTICA_APP_URL`, el contenedor:

1. Ejecuta `multica setup self-host` automáticamente
2. Inicia `multica daemon start` en segundo plano
3. El daemon permite que Kimi interactúe con tu servidor Multica

Si no configurás las URLs de Multica, el contenedor igual funciona como entorno de ejecución de Kimi standalone.

---

## 🛠️ Construcción manual

```bash
cd agent-worker
docker build -t multica-kimi-worker .
```

---

## 📚 Recursos

- [Kimi CLI GitHub](https://github.com/MoonshotAI/kimi-cli)
- [Documentación Kimi CLI](https://moonshotai.github.io/kimi-cli/)
- [Plataforma Moonshot AI](https://platform.moonshot.cn/)
- [Multica Docs](https://multica.ai/docs)
