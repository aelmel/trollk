# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :trollk, TrollkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ssJk8D+lIyLZQZWHG+4O1yuKw9ncYqqCm1rppC6cZlgzXo0nke+s2a295KnAoEje",
  render_errors: [view: TrollkWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Trollk.PubSub,
  live_view: [signing_salt: "ehaiQ9uc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
