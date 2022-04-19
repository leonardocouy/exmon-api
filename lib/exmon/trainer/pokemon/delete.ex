defmodule Exmon.Trainer.Pokemon.Delete do
  alias Ecto.UUID
  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid UUID"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_pokemon(uuid) do
      nil -> {:error, :not_found}
      pokemon -> Repo.delete(pokemon)
    end
  end

  defp fetch_pokemon(uuid), do: Repo.get(TrainerPokemon, uuid)
end
