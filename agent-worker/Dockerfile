# =============================================================================
# Kimi + Multica Agent Worker
# =============================================================================
FROM python:3.13-slim

LABEL maintainer="holk26"
LABEL description="Kimi + Multica Agent Worker"

# -----------------------------------------------------------------------------
# 1. Dependencias base
# -----------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    ca-certificates \
    openssh-client \
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
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 2. Node.js (desde NodeSource para versión reciente)
# -----------------------------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 3. Kimi CLI (Moonshot AI)
# -----------------------------------------------------------------------------
RUN pip install --no-cache-dir kimi-cli

# -----------------------------------------------------------------------------
# 4. Multica CLI (best-effort — install script may not always be available)
# -----------------------------------------------------------------------------
RUN mkdir -p /root/.local/bin && \
    (curl -fsSL https://multica.ai/install.sh | bash && \
     ln -sf /root/.local/bin/multica /usr/local/bin/multica 2>/dev/null) || \
    echo "⚠️  Multica install script unavailable — skipping"

# -----------------------------------------------------------------------------
# 5. Configurar entorno
# -----------------------------------------------------------------------------
WORKDIR /workspace

RUN mkdir -p /workspace/projects \
    /root/.config/kimi \
    /root/.config/multica \
    /root/.cache/kimi \
    /app

# -----------------------------------------------------------------------------
# 6. Healthcheck
# -----------------------------------------------------------------------------
RUN printf '#!/bin/bash\nexit 0\n' > /app/healthcheck.sh && \
    chmod +x /app/healthcheck.sh

# -----------------------------------------------------------------------------
# 7. Entrypoint
# -----------------------------------------------------------------------------
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 9090

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/healthcheck.sh

ENTRYPOINT ["/app/entrypoint.sh"]
