defmodule Exmon.Trainer.Get do
  alias Ecto.UUID
  alias Exmon.{Repo, Trainer}

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid UUID"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Trainer, uuid) do
      nil -> {:error, {:not_found, "Trainer not found!"}}
      trainer -> {:ok, trainer}
    end
  end
end
