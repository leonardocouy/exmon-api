defmodule ExmonWeb.TrainersController do
  use ExmonWeb, :controller

  alias ExmonWeb.Auth.Guardian

  action_fallback ExmonWeb.FallbackController

  def create(conn, params) do
    with {:ok, trainer} <- Exmon.create_trainer(params),
         {:ok, token, claims} <- Guardian.encode_and_sign(trainer) do
      conn
      |> put_status(:created)
      |> render("create.json", %{trainer: trainer, token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    id
    |> Exmon.fetch_trainer()
    |> handle_response(conn, "show.json", :ok)
  end

  def update(conn, params) do
    params
    |> Exmon.update_trainer()
    |> handle_response(conn, "update.json", :ok)
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Exmon.delete_trainer()
    |> handle_delete(conn)
  end

  defp handle_delete({:ok, _trainer}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:error, _reason} = error, _conn), do: error

  defp handle_response({:ok, trainer}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, trainer: trainer)
  end

  defp handle_response({:error, {:not_found, _message}} = error, _conn, _view, _status), do: error

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
