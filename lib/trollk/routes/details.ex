defmodule Trollk.Routes.Details do
  @moduledoc """
  Method to get segment and station details based on osm
  """
  require Logger

  def get(osm) do
    case Cachex.get(:routes_details, osm) |> IO.inspect() do
      {:ok, nil} ->
        details = get_details(osm)
        Cachex.put(:routes_details, osm, details)
        details

      {:ok, details} ->
        details

      _ ->
        get_details(osm)
    end
  end

  defp get_details(osm) do
    try do
      segment = get_segment(osm)
      stations = get_station(osm)

      {:ok,
       %{
         "stations" => stations,
         "segment" => segment
       }}
    rescue
      e in Trollk.Routes.Exception ->
        {:error, e.message}
    end
  end

  defp get_segment(osm) do
    host = Application.fetch_env!(:trollk, __MODULE__) |> Keyword.get(:host)

    http_call(
      "#{host}/api/interpreter?data=[out:json];relation%20(#{osm})%3B%3E%3E%3Bway._%3Bout%20geom%3B"
    )
  end

  defp get_station(osm) do
    host = Application.fetch_env!(:trollk, __MODULE__) |> Keyword.get(:host)

    http_call(
      "#{host}/api/interpreter?data=[out:json];relation%20(#{osm})%3B>>%3Bnode._%20[public_transport%3Dplatform]%3Bout%3B"
    )
  end

  defp http_call(url) do
    Logger.debug("Call url #{url}")

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        Logger.debug("Got success")

        case Jason.decode(response.body) do
          {:ok, payload} ->
            payload

          {:error, error} ->
            raise Trollk.Routes.Exception, message: error
        end

      {:ok, %HTTPoison.Response{status_code: code} = response} ->
        Logger.warn("Received unexpected status code #{code}")
        raise Trollk.Routes.Exception, message: "Unexpected result"

      error ->
        raise Trollk.Routes.Exception, message: "Unexpected error #{inspect(error)}"
    end
  end
end
