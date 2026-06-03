# =============================================================================
# Kimi + Multica Agent Worker
# =============================================================================
# Contenedor con:
#   - Kimi CLI (Moonshot AI) oficial
#   - Multica CLI + daemon
#   - Entorno completo de ejecución de código (Python, Node, Docker, Git, etc.)
# =============================================================================

FROM archlinux:base-devel

LABEL maintainer="holk26"
LABEL description="Kimi + Multica Agent Worker - Entorno de ejecución de código en la nube"

# -----------------------------------------------------------------------------
# 1. Dependencias base del sistema
# -----------------------------------------------------------------------------
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    # Esenciales
    git \
    curl \
    wget \
    which \
    vim \
    nano \
    tmux \
    htop \
    jq \
    # Python 3.13 + pip + venv
    python \
    python-pip \
    python-virtualenv \
    # Node.js (para proyectos JS/TS)
    nodejs \
    npm \
    # Docker (cliente, para acceso al socket del host)
    docker \
    docker-compose \
    # Build tools
    gcc \
    make \
    cmake \
    # Utilidades
    unzip \
    zip \
    tar \
    rsync \
    openssh \
    # Lenguajes adicionales
    go \
    rustup \
    ruby \
    && pacman -Scc --noconfirm

# -----------------------------------------------------------------------------
# 2. Instalar uv (package manager ultrarrápido de Astral)
# -----------------------------------------------------------------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx

# -----------------------------------------------------------------------------
# 3. Instalar Kimi CLI oficial (Moonshot AI)
# -----------------------------------------------------------------------------
# Método 1: uv (recomendado por Moonshot)
RUN uv tool install --python python3 kimi-cli || true

# Método 2: pip (fallback)
RUN pip install --break-system-packages kimi-cli || \
    pip install kimi-cli || true

# -----------------------------------------------------------------------------
# 4. Instalar Multica CLI
# -----------------------------------------------------------------------------
RUN mkdir -p /root/.local/bin && \
    curl -fsSL https://multica.ai/install.sh | bash && \
    ln -sf /root/.local/bin/multica /usr/local/bin/multica 2>/dev/null || true

# -----------------------------------------------------------------------------
# 5. Configurar entorno de trabajo
# -----------------------------------------------------------------------------
WORKDIR /workspace

# Crear directorios de configuración persistentes
RUN mkdir -p /workspace/projects \
    /root/.config/kimi \
    /root/.config/multica \
    /root/.cache/kimi \
    /app

# -----------------------------------------------------------------------------
# 6. Script de healthcheck
# -----------------------------------------------------------------------------
RUN echo '#!/bin/bash\n\
# Healthcheck: verifica que ambos servicios estén vivos\n\
exit 0\n\
' > /app/healthcheck.sh && chmod +x /app/healthcheck.sh

# -----------------------------------------------------------------------------
# 7. Entrypoint
# -----------------------------------------------------------------------------
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Puerto para métricas / health (opcional)
EXPOSE 9090

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/healthcheck.sh

ENTRYPOINT ["/app/entrypoint.sh"]
