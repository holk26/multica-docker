# Workerd - Cloudflare Workers Runtime

Contenedor Docker con **workerd** (runtime de Cloudflare Workers).

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `Dockerfile` | Imagen `cloudflare/workerd:latest` |
| `config.capnp` | Configuración del runtime |
| `worker.js` | Entrypoint del Worker |

## Endpoints

| Ruta | Método | Descripción |
|------|--------|-------------|
| `GET /health` | `GET` | Health check |
| `POST /echo` | `POST` | Echo |
| `GET/POST /api/*` | `*` | Proxy a backend Multica |

## Puerto

| Modo | Puerto |
|------|--------|
| Local | `localhost:8787` |
| Dokploy | `8787` |
