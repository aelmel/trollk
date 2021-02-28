defmodule Trollk.Mqtt.Handler do
  @moduledoc """
  Mqtt client handler
  """

  use Tortoise.Handler
  require Logger

  def init(args) do
    {:ok, args}
  end

  def connection(_status, state) do
    {:ok, state}
  end

  def handle_message(["telemetry", "transport", track], payload, state) do
    decoded = Jason.decode!(payload)
    Logger.info("Track #{track} with payload #{inspect(decoded)}")
    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end
end
