defmodule Trollk.Roataway.Vehicles do
  @moduledoc """
  GenServer to handle routes details
  """

  use GenServer

  def start_link(_init_args) do
    # you may want to register your server with `name: __MODULE__`
    # as a third argument to `start_link`

    GenServer.start_link(__MODULE__, ["priv/seeds/config/vehicles.csv"], name: __MODULE__)
  end

  def init([routes_path]) do
    state =
      routes_path
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.reduce(%{}, fn [
                               tracker_id,
                               organization,
                               board,
                               vehicle_type,
                               model,
                               door_count,
                               release_date,
                               articulated,
                               accessibility
                             ],
                             acc ->
        vehicle_details =
          Map.new()
          |> Map.put(:tracker_id, tracker_id)
          |> Map.put(:organization, organization)
          |> Map.put(:board, board)
          |> Map.put(:vehicle_type, vehicle_type)
          |> Map.put(:model, model)
          |> Map.put(:door_count, door_count)
          |> Map.put(:release_date, release_date)
          |> Map.put(:articulated, articulated)
          |> Map.put(:accessibility, accessibility)

        Map.put(acc, board, vehicle_details)
      end)

    {:ok, state}
  end

  def get_details(board) do
    case GenServer.call(__MODULE__, {:get_details, board}) do
      nil ->
        {:error, "No such vehicale"}

      details ->
        {:ok, details}
    end
  end

  def handle_call({:get_details, board}, _from, state) do
    details = Map.get(state, board)
    {:reply, details, state}
  end
end
