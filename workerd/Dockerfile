# Cloudflare workerd runtime
FROM cloudflare/workerd:latest

WORKDIR /app

COPY config.capnp /app/config.capnp
COPY worker.js /app/worker.js

EXPOSE 8787

ENTRYPOINT ["workerd"]
CMD ["serve", "/app/config.capnp", "--verbose"]
