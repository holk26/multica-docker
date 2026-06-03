#!/bin/bash
set -e

# =============================================================================
# Kimi + Multica Agent Worker — Entrypoint
# =============================================================================
# Inicia el demonio de Multica y mantiene Kimi CLI configurado y listo.
# Uso: docker compose up -d kimi-worker
#       docker exec -it multica-kimi-worker-1 bash
#       → dentro: `kimi` para iniciar el agente interactivo
# =============================================================================

echo "═══════════════════════════════════════════════════════════════════════"
echo "  🧠 Kimi + Multica Agent Worker"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""

# -----------------------------------------------------------------------------
# Configuración por defecto
# -----------------------------------------------------------------------------
MULTICA_SERVER_URL="${MULTICA_SERVER_URL:-}"
MULTICA_APP_URL="${MULTICA_APP_URL:-}"
MULTICA_AUTH_TOKEN="${MULTICA_AUTH_TOKEN:-}"
KIMI_API_KEY="${KIMI_API_KEY:-${MOONSHOT_API_KEY:-}}"

cd /workspace

# -----------------------------------------------------------------------------
# 1. Verificar dependencias principales
# -----------------------------------------------------------------------------
echo "📦 Verificando dependencias..."

if command -v kimi &> /dev/null; then
    echo "  ✅ Kimi CLI: $(kimi --version 2>/dev/null || echo 'instalado')"
else
    echo "  ⚠️  Kimi CLI no encontrado en PATH"
fi

if command -v multica &> /dev/null; then
    echo "  ✅ Multica CLI: $(multica --version 2>/dev/null || echo 'instalado')"
else
    echo "  ❌ Multica CLI no encontrado"
    exit 1
fi

if command -v docker &> /dev/null; then
    echo "  ✅ Docker client: $(docker --version 2>/dev/null || echo 'instalado')"
else
    echo "  ⚠️  Docker client no encontrado (necesitás montar /var/run/docker.sock)"
fi

if command -v uv &> /dev/null; then
    echo "  ✅ uv: $(uv --version 2>/dev/null || echo 'instalado')"
fi

echo ""

# -----------------------------------------------------------------------------
# 2. Configurar Kimi CLI
# -----------------------------------------------------------------------------
if [ -n "$KIMI_API_KEY" ]; then
    echo "🔑 Configurando Kimi CLI..."

    # Kimi CLI usa variables de entorno; no requiere archivo de config obligatorio.
    # Algunas versiones usan MOONSHOT_API_KEY, otras KIMI_API_KEY.
    export MOONSHOT_API_KEY="$KIMI_API_KEY"
    export KIMI_API_KEY="$KIMI_API_KEY"

    # Intentar autenticación silenciosa si el CLI lo soporta
    if kimi auth status &>/dev/null || kimi --version &>/dev/null; then
        echo "  ✅ Kimi CLI autenticado"
    else
        echo "  ℹ️  Kimi CLI listo (usa variable de entorno)"
    fi
else
    echo "⚠️  KIMI_API_KEY no definida."
    echo "   Podés configurarla en el .env o ejecutar 'kimi login' manualmente."
fi

echo ""

# -----------------------------------------------------------------------------
# 3. Configurar Multica CLI (self-host)
# -----------------------------------------------------------------------------
if [ -n "$MULTICA_SERVER_URL" ] && [ -n "$MULTICA_APP_URL" ]; then
    echo "🔧 Configurando Multica CLI para self-host..."
    echo "   Server: $MULTICA_SERVER_URL"
    echo "   App:    $MULTICA_APP_URL"

    multica setup self-host \
        --server-url "$MULTICA_SERVER_URL" \
        --app-url "$MULTICA_APP_URL" \
        --skip-browser \
        2>/dev/null || true

    if [ -n "$MULTICA_AUTH_TOKEN" ]; then
        echo "   Token:  configurado"
    else
        echo "   Token:  no definido (se puede autenticar manualmente con 'multica login')"
    fi
else
    echo "⚠️  MULTICA_SERVER_URL / MULTICA_APP_URL no definidas."
    echo "   El demonio de Multica no se iniciará."
fi

echo ""

# -----------------------------------------------------------------------------
# 4. Iniciar demonio de Multica (en segundo plano)
# -----------------------------------------------------------------------------
DAEMON_PID=""

if [ -n "$MULTICA_SERVER_URL" ] && [ -n "$MULTICA_APP_URL" ]; then
    echo "🚀 Iniciando demonio de Multica..."
    multica daemon start &
    DAEMON_PID=$!

    sleep 3

    echo "🔍 Estado del demonio:"
    multica daemon status 2>/dev/null || echo "   (daemon en arranque)"
    echo ""
fi

# -----------------------------------------------------------------------------
# 5. Resumen del entorno
# -----------------------------------------------------------------------------
echo "═══════════════════════════════════════════════════════════════════════"
echo "  ✅ Agent Worker listo"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo "  🖥️  Para entrar al contenedor y usar Kimi:"
echo "     docker exec -it <nombre-contenedor> bash"
echo ""
echo "  🤖 Para iniciar Kimi interactivo:"
echo "     kimi"
echo ""

if [ -n "$DAEMON_PID" ]; then
    echo "  📡 Multica Daemon PID: $DAEMON_PID"
    echo "     Logs: multica daemon logs"
fi

echo ""
echo "  📁 Workspace: /workspace"
echo "  🔑 API Keys cargadas: $( [ -n "$KIMI_API_KEY" ] && echo 'Kimi' || echo 'ninguna' )"
echo ""
echo "  💡 Consejos:"
echo "     • Montá tu proyecto en /workspace/projects para persistir cambios"
echo "     • Kimi puede ejecutar shell, leer/escribir archivos y más"
echo "     • El daemon de Multica permite que Kimi interactúe con tu servidor"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"

# -----------------------------------------------------------------------------
# 6. Mantener el contenedor vivo
# -----------------------------------------------------------------------------
# Si el daemon está corriendo, esperamos a que termine.
# Si no, dormimos para siempre (permitiendo exec).
if [ -n "$DAEMON_PID" ]; then
    wait $DAEMON_PID
else
    # Loop infinito que permite docker exec
    while true; do
        sleep 3600
    done
fi
