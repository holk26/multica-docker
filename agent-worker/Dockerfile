# =============================================================================
# Kimi + Multica Agent Worker
# =============================================================================
# Contenedor ligero con:
#   - Kimi CLI (Moonshot AI) oficial
#   - Multica CLI + daemon
#   - Python 3.13, Node.js, Docker client, Git
# =============================================================================

FROM python:3.13-slim

LABEL maintainer="holk26"
LABEL description="Kimi + Multica Agent Worker"

# -----------------------------------------------------------------------------
# 1. Dependencias base (apt es más rápido que pacman)
# -----------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    ca-certificates \
    openssh-client \
    gnupg \
    lsb-release \
    vim \
    nano \
    tmux \
    htop \
    jq \
    unzip \
    zip \
    make \
    gcc \
    g++ \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 2. Docker client (solo CLI, se conecta al socket del host)
# -----------------------------------------------------------------------------
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
    ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 3. Instalar uv (package manager ultrarrápido de Astral)
# -----------------------------------------------------------------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx

# -----------------------------------------------------------------------------
# 4. Instalar Kimi CLI oficial (Moonshot AI)
# -----------------------------------------------------------------------------
# Kimi CLI es un paquete Python. Lo instalamos globalmente.
RUN pip install --no-cache-dir kimi-cli

# -----------------------------------------------------------------------------
# 5. Instalar Multica CLI
# -----------------------------------------------------------------------------
RUN mkdir -p /root/.local/bin && \
    curl -fsSL https://multica.ai/install.sh | bash && \
    ln -sf /root/.local/bin/multica /usr/local/bin/multica 2>/dev/null || true

# -----------------------------------------------------------------------------
# 6. Configurar entorno de trabajo
# -----------------------------------------------------------------------------
WORKDIR /workspace

RUN mkdir -p /workspace/projects \
    /root/.config/kimi \
    /root/.config/multica \
    /root/.cache/kimi \
    /app

# -----------------------------------------------------------------------------
# 7. Script de healthcheck
# -----------------------------------------------------------------------------
RUN printf '#!/bin/bash\n# Healthcheck\nexit 0\n' > /app/healthcheck.sh && \
    chmod +x /app/healthcheck.sh

# -----------------------------------------------------------------------------
# 8. Entrypoint
# -----------------------------------------------------------------------------
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 9090

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/healthcheck.sh

ENTRYPOINT ["/app/entrypoint.sh"]
