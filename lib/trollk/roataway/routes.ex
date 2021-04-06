defmodule Trollk.Roataway.Routes do
  @moduledoc """
  GenServer to handle routes details
  """

  use GenServer

  def start_link(_init_args) do
    # you may want to register your server with `name: __MODULE__`
    # as a third argument to `start_link`

    GenServer.start_link(__MODULE__, ["priv/seeds/config/routes.csv"], name: __MODULE__)
  end

  def init([routes_path]) do
    state =
      routes_path
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.reduce(%{}, fn [route_id, route_number, route_desc, osm], acc ->
        route_details =
          Map.new()
          |> Map.put(:route_number, route_number)
          |> Map.put(:route_desc, route_desc)
          |> Map.put(:osm, osm)
          |> Map.put(:route_id, route_id)

        Map.put(acc, route_number, route_details)
      end)

    {:ok, state}
  end

  def get_details(route_number) do
    case GenServer.call(__MODULE__, {:get_details, route_number}) do
      nil ->
        {:error, "No such route"}

      details ->
        {:ok, details}
    end
  end

  def handle_call({:get_details, route_number}, _from, state) do
    route_details = Map.get(state, route_number)
    {:reply, route_details, state}
  end
end
