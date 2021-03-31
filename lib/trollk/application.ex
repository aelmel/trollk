defmodule Trollk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    mqtt_client =
      {Tortoise.Connection,
       [
         client_id: "trollk",
         handler: {Trollk.Mqtt.Handler, []},
         server: {Tortoise.Transport.Tcp, host: 'opendata.dekart.com', port: 1945},
         subscriptions: [
           {"telemetry/transport/+", 0},
           {"telemetry/route/+", 0},
           {"event/route/+", 0}
         ]
       ]}

    children = [
      # Start the Telemetry supervisor
      TrollkWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Trollk.PubSub},
      # Start the Endpoint (http/https)
      TrollkWeb.Endpoint,
      # Start a worker by calling: Trollk.Worker.start_link(arg)
      # {Trollk.Worker, arg}
      {Trollk.Roataway.Routes, []},
      {Trollk.Roataway.Vehicles, []},
      mqtt_client
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trollk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TrollkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
