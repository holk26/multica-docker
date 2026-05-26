# Agent Worker para Multica
# Contenedor con agentes de IA (Kimi, Claude, Codex, etc.) conectados a tu Multica self-hosted

FROM archlinux:base-devel

LABEL maintainer="holk26"
LABEL description="Agent worker for Multica with AI agents support"

# Actualizar e instalar dependencias base
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    git \
    curl \
    wget \
    nodejs \
    npm \
    python \
    python-pip \
    python-virtualenv \
    openssh \
    docker \
    docker-compose \
    which \
    vim \
    nano \
    && pacman -Scc --noconfirm

# Instalar CLI de Multica
RUN mkdir -p /root/.local/bin && \
    curl -fsSL https://multica.ai/install.sh | bash && \
    ln -sf /root/.local/bin/multica /usr/local/bin/multica 2>/dev/null || true

# Instalar agentes de IA globales (descomentar los que necesites)
# RUN npm install -g @anthropic-ai/claude-code
# RUN npm install -g @openai/codex
# RUN npm install -g @google/gemini-cli

# Crear directorio de trabajo
WORKDIR /workspace

# Copiar entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Puerto para métricas (opcional)
EXPOSE 9090

ENTRYPOINT ["/app/entrypoint.sh"]
