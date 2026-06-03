# 🚀 Desplegar Multica en Dokploy

Esta guía te lleva paso a paso para montar **Multica** (https://multica.ai) en tu VPS usando **Dokploy**.

---

## 📋 Requisitos Previos

- Un VPS con Docker y Dokploy instalados
- Dominio(s) apuntando a tu VPS
- Acceso al panel de Dokploy

---

## 🏗️ Arquitectura

| Servicio | Imagen | Puerto | Externo |
|----------|--------|--------|---------|
| PostgreSQL | `pgvector/pgvector:pg17` | 5432 | ❌ No |
| Backend API | `ghcr.io/multica-ai/multica-backend` | 8080 | ✅ Sí (API) |
| Frontend Web | `ghcr.io/multica-ai/multica-web` | 3000 | ✅ Sí (App) |
| **Kimi Worker** | `agent-worker/Dockerfile` | — | ❌ No (exec interno) |

> 🧠 El **Kimi Worker** es un contenedor con [Kimi CLI](https://github.com/MoonshotAI/kimi-cli) (Moonshot AI) + demonio de Multica. Se accede vía `docker exec` para tener un entorno de ejecución de código en la nube siempre disponible. Ver [`agent-worker/README.md`](agent-worker/README.md).

---

## 📁 Archivos en este Directorio

```
.
├── docker-compose.yml    # Compose adaptado para Dokploy
├── .env.example          # Variables de entorno (plantilla)
└── DOKPLOY-GUIDE.md      # Esta guía
```

---

## ⚙️ Paso 1: Preparar Variables de Entorno

### 1.1 Genera secretos seguros

```bash
# JWT_SECRET (64+ caracteres)
openssl rand -base64 64

# POSTGRES_PASSWORD
openssl rand -base64 32
```

### 1.2 Crea tu archivo `.env`

```bash
cp .env.example .env
nano .env
```

**Edita OBLIGATORIAMENTE estas variables:**

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `POSTGRES_PASSWORD` | Contraseña de la base de datos | `generada arriba` |
| `JWT_SECRET` | Secreto para tokens JWT | `generado arriba` |
| `FRONTEND_ORIGIN` | URL pública del frontend | `https://multica.tudominio.com` |
| `MULTICA_APP_URL` | Igual que arriba | `https://multica.tudominio.com` |
| `MULTICA_PUBLIC_URL` | URL pública del backend API | `https://multica-api.tudominio.com` |
| `CORS_ALLOWED_ORIGINS` | Origen permitido para CORS | `https://multica.tudominio.com` |

**Email (elige una opción):**

- **Opción A (Recomendada):** Configura `RESEND_API_KEY` desde [resend.com](https://resend.com)
- **Opción B:** Configura las variables `SMTP_*` con tu servidor de correo
- **Sin email:** Los códigos de verificación aparecerán en los logs del backend

**Kimi Worker (opcional pero recomendado):**

| Variable | Descripción | Dónde obtener |
|----------|-------------|---------------|
| `KIMI_API_KEY` | API Key de Moonshot AI para Kimi CLI | [platform.moonshot.cn](https://platform.moonshot.cn/) |
| `MULTICA_AUTH_TOKEN` | Token de tu cuenta en Multica | Logueate en la web → Settings → API Tokens |

---

## 🖥️ Paso 2: Crear el Proyecto en Dokploy

### 2.1 Crea el Proyecto

1. Entra al panel de Dokploy
2. Click en **"Create Project"**
3. Nombre: `multica`
4. Click **"Create"**

### 2.2 Crea un Environment

1. Dentro del proyecto `multica`, click en **"Create Environment"**
2. Nombre: `production`
3. Click **"Create"**

### 2.3 Crea el Servicio Compose

1. Dentro del environment `production`, click en **"Add Service"**
2. Selecciona **"Compose"**
3. Nombre: `multica-stack`
4. **Importante:** Tipo de Compose: selecciona **`docker-compose`** (no `stack`)
5. Click **"Create"**

---

## 📝 Paso 3: Configurar el Compose en Dokploy

### 3.1 Pega el docker-compose.yml

1. Abre el servicio `multica-stack`
2. Ve a la pestaña **"Compose"**
3. Pega el contenido de `docker-compose.yml`
4. Click **"Save"**

### 3.2 Configura las Variables de Entorno

1. Ve a la pestaña **"Environment"**
2. Pega TODO el contenido de tu archivo `.env`
3. Click **"Save"**

> 💡 **Tip:** En Dokploy, las variables se inyectan en TODOS los servicios del compose. Cada servicio usa solo las que necesita.

---

## 🌐 Paso 4: Configurar Dominios

### 4.1 Dominio para el Frontend

1. En el servicio `multica-stack`, ve a **"Domains"**
2. Click **"Create Domain"**
3. Selecciona el servicio: `frontend`
4. Host: `multica.tudominio.com` (o el que prefieras)
5. Port: `3000`
6. HTTPS: ✅ Habilitado (recomendado)
7. Certificate: `letsencrypt`
8. Click **"Create"**

### 4.2 Dominio para el Backend

1. Click **"Create Domain"** de nuevo
2. Selecciona el servicio: `backend`
3. Host: `multica-api.tudominio.com` (o el que prefieras)
4. Port: `8080`
5. HTTPS: ✅ Habilitado
6. Certificate: `letsencrypt`
7. Click **"Create"**

> ⚠️ **Importante:** Asegúrate de que los dominios apunten a la IP de tu VPS con registros DNS tipo A.

---

## 🚀 Paso 5: Desplegar

1. Ve a la pestaña **"General"** del servicio
2. Click en **"Deploy"**
3. Espera a que termine la descarga de imágenes y el despliegue

Puedes ver el progreso en **"Deployments"**.

---

## ✅ Paso 6: Verificar e Iniciar Sesión

### 6.1 Verifica que todo está funcionando

Abre en tu navegador:
- **Frontend:** `https://multica.tudominio.com`
- **Backend API:** `https://multica-api.tudominio.com` (debería devolver JSON o un 404 de la API)

### 6.2 Crear tu primera cuenta

1. Ve al frontend (`https://multica.tudominio.com`)
2. Introduce tu email y pide un código de verificación
3. Si configuraste **Resend/SMTP**, recibirás el código por email
4. Si **NO** configuraste email:
   - Ve a Dokploy → tu servicio `multica-stack`
   - Ve a **Logs** y filtra por el servicio `backend`
   - Busca el código de verificación en los logs
5. Introduce el código y completa el registro

### 6.3 Conectar el Kimi Worker (opcional)

Si configuraste `KIMI_API_KEY`, el contenedor `kimi-worker` se levanta automáticamente con Kimi CLI listo.

**Conectarte al worker:**

```bash
# Desde el servidor Dokploy/VPS:
docker exec -it multica-kimi-worker bash

# Dentro del contenedor:
kimi                    # Iniciar Kimi interactivo
kimi --version          # Ver versión
```

**Ver logs del worker:**

En Dokploy → servicio `multica-stack` → Logs → filtrar por `kimi-worker`.

**Uso típico:**

1. Montá tu repo en `/workspace/projects` (editá el `volumes` en `docker-compose.yml`)
2. Entrá al contenedor con `docker exec`
3. Ejecutá `kimi` y pedile que trabaje en tu código
4. Kimi puede leer/escribir archivos, ejecutar shell, lanzar Docker, etc.

> 📚 Más info en [`agent-worker/README.md`](agent-worker/README.md).

---

## 🔒 Recomendaciones de Seguridad

### Desactivar registros públicos (instancia privada)

Si solo tú usarás Multica, edita las variables:

```env
ALLOW_SIGNUP=false
ALLOWED_EMAILS=tu-email@ejemplo.com
```

Luego redeploya desde Dokploy.

### IPs de Confianza

Si usas Cloudflare u otro CDN delante de Dokploy, actualiza:

```env
MULTICA_TRUSTED_PROXIES=127.0.0.1/32,173.245.48.0/20,103.21.244.0/22,...
```

Busca los rangos IP oficiales de tu CDN.

---

## 🔄 Actualizaciones

Para actualizar Multica a la última versión:

1. Ve a Dokploy → tu servicio `multica-stack`
2. Ve a **General**
3. Click en **"Redeploy"**

Esto descargará las imágenes `latest` más recientes.

Para fijar una versión específica, cambia en `.env`:
```env
MULTICA_IMAGE_TAG=v0.2.25
```

Y luego redeploya.

### Actualizar Kimi Worker

El `kimi-worker` se construye desde el `Dockerfile` local. Para actualizarlo (por ejemplo, después de modificar el `Dockerfile`):

1. Editá `agent-worker/Dockerfile` o `agent-worker/entrypoint.sh`
2. En Dokploy, redeploya el servicio `multica-stack`
3. Dokploy reconstruirá la imagen automáticamente

Para forzar una reconstrucción limpia:
```bash
# Desde el servidor:
docker compose -f /path/to/compose.yml build --no-cache kimi-worker
docker compose -f /path/to/compose.yml up -d kimi-worker
```

---

## 🆘 Solución de Problemas

### Error de CORS

Verifica que `FRONTEND_ORIGIN` y `CORS_ALLOWED_ORIGINS` coincidan EXACTAMENTE con tu dominio del frontend (incluyendo `https://`).

### No recibo emails

- Verifica tu `RESEND_API_KEY` o configuración SMTP
- Revisa los logs del backend en Dokploy para ver el código de verificación

### El frontend no conecta al backend

- Verifica que `MULTICA_PUBLIC_URL` sea accesible públicamente
- Revisa que el dominio del backend tenga el puerto `8080` en Dokploy

### Error de base de datos

- Verifica que `POSTGRES_PASSWORD` esté definida
- Revisa los logs del servicio `postgres` para errores de conexión

---

## 📚 Recursos

- [Documentación oficial de Multica](https://multica.ai/docs)
- [Self-hosting guide (GitHub)](https://github.com/multica-ai/multica/blob/main/SELF_HOSTING.md)
- [Dokploy Documentation](https://docs.dokploy.com)
