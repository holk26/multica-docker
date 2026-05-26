export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const method = request.method;

    if (url.pathname === "/health" && method === "GET") {
      return new Response(JSON.stringify({ status: "ok", runtime: "workerd" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    if (url.pathname === "/echo" && method === "POST") {
      const body = await request.text();
      return new Response(JSON.stringify({ echo: body, timestamp: Date.now() }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    if (url.pathname.startsWith("/api/")) {
      const apiUrl = new URL(url.pathname + url.search, "https://space-api.moonsbow.com");
      const apiRequest = new Request(apiUrl, {
        method,
        headers: request.headers,
        body: request.body,
      });
      return fetch(apiRequest);
    }

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
