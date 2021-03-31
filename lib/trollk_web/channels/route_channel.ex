defmodule TrollkWeb.RouteChannel do
  use Phoenix.Channel

  @moduledoc """
  Module to manage routes channel
  """

  require Logger

  def join("route:" <> route_id, params, socket) do
    Logger.info("Joined on routed #{route_id}")
    {:ok, socket}
  end

  def handle_in("stop", _, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shut down"}}, socket}
  end

  def handle_in(event, payload, socket) do
    Logger.warn("Received unhandled event #{event}, with payload #{inspect(payload)}")
    {:noreply, socket}
  end
end
