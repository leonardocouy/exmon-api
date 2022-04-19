defmodule ExmonWeb.TrainerPokemonsController do
  use ExmonWeb, :controller

  action_fallback ExmonWeb.FallbackController

  def create(conn, params) do
    params
    |> Exmon.create_trainer_pokemon()
    |> handle_response(conn, "create.json", :created)
  end

  defp handle_response({:ok, pokemon}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, pokemon: pokemon)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error

  defp handle_response({:error, :not_found} = error, _conn, _view, _status), do: error
end
