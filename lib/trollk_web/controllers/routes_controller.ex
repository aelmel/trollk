defmodule TrollkWeb.RoutesController do
  @moduledoc """
  Module to retreive route stations and segments
  """
  use TrollkWeb, :controller
  alias Trollk.Routes.Details
  require Logger

  def get_route_details(conn, %{"route" => route}) do
    case Trollk.Roataway.Routes.get_details(route) do
      {:ok, details} ->
        osm = Map.get(details, :osm)
        case Details.get(osm) do
          {:ok, details} ->
            json(conn, details)
          {:error, error} ->
            conn
            |> put_status(500)
            |> json( %{error: error})
        end

      {:error, error} ->
        Logger.warn("Error received #{error}")
    end
  end

end
