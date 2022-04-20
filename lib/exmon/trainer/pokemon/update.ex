defmodule Exmon.Trainer.Pokemon.Update do
  alias Ecto.UUID
  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, "Invalid UUID"}
      {:ok, _uuid} -> update(fetch_trainer_pokemon(uuid), params)
    end
  end

  defp update(trainer_pokemon, _params) when trainer_pokemon == nil,
    do: {:error, {:not_found, "Trainer Pokemon not found!"}}

  defp update(trainer_pokemon, params), do: update_trainer_pokemon(trainer_pokemon, params)

  defp fetch_trainer_pokemon(uuid), do: Repo.get(TrainerPokemon, uuid)

  defp update_trainer_pokemon(trainer_pokemon, params) do
    trainer_pokemon
    |> TrainerPokemon.update_changeset(params)
    |> Repo.update()
  end
end
