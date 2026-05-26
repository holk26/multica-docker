using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
  services = [
    (name = "main", worker = .mainWorker),
  ],
  sockets = [
    (name = "http", address = "*:8787", http = (), service = "main"),
  ]
);

const mainWorker :Workerd.Worker = (
  modules = [
    (name = "worker", esModule = embed "worker.js"),
  ],
  compatibilityDate = "2024-01-15",
);
