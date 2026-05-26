#!/bin/bash
set -e

echo "═══════════════════════════════════════════════════"
echo "  Multica Agent Worker"
echo "═══════════════════════════════════════════════════"
echo ""

# Verificar variables requeridas
if [ -z "$MULTICA_SERVER_URL" ]; then
  echo "❌ Error: MULTICA_SERVER_URL no está definida"
  echo "   Ejemplo: https://space-api.moonsbow.com"
  exit 1
fi

if [ -z "$MULTICA_APP_URL" ]; then
  echo "❌ Error: MULTICA_APP_URL no está definida"
  echo "   Ejemplo: https://space.moonsbow.com"
  exit 1
fi

if [ -z "$MULTICA_AUTH_TOKEN" ]; then
  echo "⚠️  MULTICA_AUTH_TOKEN no está definida."
  echo "    El daemon puede pedirte autenticación manual."
fi

echo "🌐 Server URL: $MULTICA_SERVER_URL"
echo "🌐 App URL:    $MULTICA_APP_URL"
echo ""

# Verificar que multica CLI está disponible
if ! command -v multica &> /dev/null; then
  echo "❌ Error: multica CLI no encontrado"
  exit 1
fi

echo "✅ multica CLI encontrado: $(multica --version 2>/dev/null || echo 'version desconocida')"
echo ""

# Configurar el CLI para self-host
echo "🔧 Configurando multica para self-host..."
multica setup self-host \
  --server-url "$MULTICA_SERVER_URL" \
  --app-url "$MULTICA_APP_URL" \
  --skip-browser \
  2>/dev/null || true

echo ""
echo "📋 Agentes disponibles en el contenedor:"
echo "───────────────────────────────────────────────"

# Listar agentes detectados
AGENTS_FOUND=""

for agent in claude codex copilot cursor gemini kimi kiro opencode openclaw pi hermes; do
  if command -v "$agent" &> /dev/null || command -v "$agent-cli" &> /dev/null; then
    echo "  ✅ $agent"
    AGENTS_FOUND="$AGENTS_FOUND $agent"
  fi
done

if [ -z "$AGENTS_FOUND" ]; then
  echo "  ⚠️  Ningún agente de IA detectado en PATH"
  echo "      Instalá agentes con npm install -g <agente>"
fi

echo ""
echo "🚀 Iniciando daemon de Multica..."
echo "───────────────────────────────────────────────"

# Iniciar el daemon en segundo plano
multica daemon start &
DAEMON_PID=$!

sleep 3

echo ""
echo "🔍 Verificando estado del daemon..."
multica daemon status || true

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Agent Worker listo"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  Daemon PID: $DAEMON_PID"
echo "  Server:     $MULTICA_SERVER_URL"
echo "  Logs:       multica daemon logs"
echo ""
echo "  Para ver logs en tiempo real:"
echo "    docker compose logs -f agent-worker"
echo ""

# Mantener el contenedor vivo y monitorear el daemon
wait $DAEMON_PID
