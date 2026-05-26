# Multica Self-Hosted

Configuración lista para desplegar [Multica](https://multica.ai) en tu propia infraestructura usando Docker Compose.

## 🚀 Opciones de despliegue

| Modo | Archivo | Descripción |
|------|---------|-------------|
| 🏠 **Local** | `docker-compose.local.yml` | Desarrollo / pruebas en tu máquina |
| 🌐 **Dokploy (VPS)** | `docker-compose.yml` | Producción en tu VPS con Dokploy |

---

## 🏠 Local

### Requisitos
- Docker
- Docker Compose

### Inicio rápido

```bash
# 1. Clonar el repo
git clone https://github.com/tu-usuario/multica-selfhosted.git
cd multica-selfhosted

# 2. Copiar y editar variables de entorno
cp .env.example .env
# Edita .env con tus valores (mínimo: POSTGRES_PASSWORD, JWT_SECRET)

# 3. Levantar servicios
docker compose -f docker-compose.local.yml up -d

# 4. Acceder
# Frontend: http://localhost:3000
# API:      http://localhost:8080
```

### Ver logs del backend
```bash
docker compose -f docker-compose.local.yml logs backend -f
```

### Parar
```bash
docker compose -f docker-compose.local.yml down
```

---

## 🌐 Dokploy (VPS)

Ver la guía completa en [`DOKPLOY-GUIDE.md`](DOKPLOY-GUIDE.md).

### Resumen rápido

1. Crear proyecto y environment en Dokploy
2. Añadir servicio **Compose** (tipo `docker-compose`)
3. Pegar `docker-compose.yml`
4. Pegar variables de entorno desde `.env`
5. Configurar 2 dominios:
   - `frontend` → puerto `3000`
   - `backend` → puerto `8080`
6. Deploy

---

## ⚙️ Variables de entorno obligatorias

| Variable | Descripción |
|----------|-------------|
| `POSTGRES_PASSWORD` | Contraseña de la base de datos |
| `JWT_SECRET` | Secreto para firmar tokens JWT |
| `FRONTEND_ORIGIN` | URL pública del frontend |
| `MULTICA_APP_URL` | URL pública de la app |
| `MULTICA_PUBLIC_URL` | URL pública del backend API |

Ver `.env.example` para todas las opciones disponibles.

---

## 📧 Email

Para recibir códigos de verificación por email, configura **una** de estas opciones:

- **Resend** (recomendado): `RESEND_API_KEY` desde [resend.com](https://resend.com)
- **SMTP**: variables `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`

Si no configuras email, los códigos se imprimen en los logs del backend.

---

## 🔒 Seguridad

Para instancias privadas, recomendamos:

```env
ALLOW_SIGNUP=false
ALLOWED_EMAILS=tu-email@ejemplo.com
```

---

## 📚 Recursos

- [Documentación oficial Multica](https://multica.ai/docs)
- [Repositorio oficial](https://github.com/multica-ai/multica)
- [Dokploy Docs](https://docs.dokploy.com)

---

## ⚠️ Disclaimer

Este repositorio contiene configuraciones de terceros. Las imágenes Docker oficiales son de [multica-ai](https://github.com/multica-ai). No afiliado oficialmente con Multica.
