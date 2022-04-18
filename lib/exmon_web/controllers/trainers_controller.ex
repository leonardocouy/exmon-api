defmodule ExmonWeb.TrainersController do
  use ExmonWeb, :controller

  def create(conn, params) do
    params
    |> Exmon.create_trainer()
    |> handle_response(conn)
  end

  defp handle_response({:ok, trainer}, conn) do
    conn
    |> put_status(:created)
    |> render("create.json", trainer: trainer)
  end
end
