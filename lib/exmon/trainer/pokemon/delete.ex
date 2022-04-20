defmodule Exmon.Trainer.Pokemon.Delete do
  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon.Get

  def call(id) do
    case Get.call(id) do
      {:ok, trainer_pokemon} -> Repo.delete(trainer_pokemon)
      {:error, reason} -> {:error, reason}
    end
  end
end
