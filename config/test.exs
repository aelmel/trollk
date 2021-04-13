use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trollk, TrollkWeb.Endpoint,
  http: [port: 4002],
  server: false

config :trollk, Trollk.Routes.Details, host: "https://overpass-api.de"
# Print only warnings and errors during test
config :logger, level: :warn
