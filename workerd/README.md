# 🚀 Workerd - Cloudflare Workers Runtime

Carpeta para correr **workerd** (runtime de código abierto de Cloudflare Workers) como un contenedor Docker dentro de tu stack de Multica.

## 📁 Archivos

| Archivo | Descripción |
|---------|-------------|
| `Dockerfile` | Imagen basada en `cloudflare/workerd:latest` |
| `config.capnp` | Configuración del runtime (Cap'n Proto) |
| `worker.js` | Entrypoint del Worker (JavaScript) |

## 🔌 Endpoints del worker

| Ruta | Método | Descripción |
|------|--------|-------------|
| `GET /health` | `GET` | Health check |
| `POST /echo` | `POST` | Echo de lo que le enviés |
| `GET/POST /api/*` | `*` | Proxy a tu backend de Multica |

## 🛠️ Personalización

Editá `worker.js` para agregar lógica propia:

```javascript
// Ejemplo: ruta custom
if (url.pathname === "/mi-ruta") {
  return new Response("Hola mundo!");
}
```

Para pasar variables de entorno al worker, agregalas en `config.capnp`:

```capnp
bindings = [
  (name = "MI_API_KEY", text = env.MI_API_KEY),
],
```

## 🌐 En Dokploy

En la UI de Dokploy, agregá un dominio apuntando al servicio `workerd` en el puerto **8787**.

```
https://worker.moonsbow.com → workerd:8787
```

## 📖 Docs

- [workerd repo](https://github.com/cloudflare/workerd)
- [Cloudflare Workers docs](https://developers.cloudflare.com/workers/)
