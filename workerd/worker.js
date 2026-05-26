/**
 * Worker de ejemplo para workerd (Cloudflare Workers runtime)
 * 
 * Para agregar rutas, editá este archivo y redeployá.
 */

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const method = request.method;

    // Health check
    if (url.pathname === "/health" && method === "GET") {
      return new Response(JSON.stringify({ status: "ok", runtime: "workerd" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Echo endpoint
    if (url.pathname === "/echo" && method === "POST") {
      const body = await request.text();
      return new Response(JSON.stringify({ echo: body, timestamp: Date.now() }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // API proxy a tu backend de Multica
    if (url.pathname.startsWith("/api/")) {
      // Proxy a tu backend API
      const apiUrl = new URL(url.pathname + url.search, "https://space-api.moonsbow.com");
      const apiRequest = new Request(apiUrl, {
        method,
        headers: request.headers,
        body: request.body,
      });
      return fetch(apiRequest);
    }

    // Default
    return new Response(
      JSON.stringify({
        message: "workerd running",
        runtime: "workerd",
        version: "1.0",
        endpoints: ["/health", "/echo", "/api/*"],
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  },
};
