defmodule Exmon.Trainer.Pokemon.Update do
  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon
  alias Exmon.Trainer.Pokemon.Get

  def call(%{"id" => uuid} = params) do
    case Get.call(uuid) do
      {:ok, trainer_pokemon} -> update_trainer_pokemon(trainer_pokemon, params)
      {:error, reason} -> {:error, reason}
    end
  end

  defp update_trainer_pokemon(trainer_pokemon, params) do
    trainer_pokemon
    |> TrainerPokemon.update_changeset(params)
    |> Repo.update()
  end
end
