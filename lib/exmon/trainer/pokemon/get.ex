defmodule Exmon.Trainer.Pokemon.Get do
  alias Ecto.UUID
  alias Exmon.{Trainer.Pokemon, Repo}

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid UUID"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, :not_found}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
