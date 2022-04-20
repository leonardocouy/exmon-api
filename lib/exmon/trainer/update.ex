defmodule Exmon.Trainer.Update do
  alias Exmon.{Repo, Trainer}
  alias Exmon.Trainer.Get

  def call(%{"id" => uuid} = params) do
    case Get.call(uuid) do
      {:ok, trainer} -> update_trainer(trainer, params)
      {:error, reason} -> {:error, reason}
    end
  end

  defp update_trainer(trainer, params) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end
end
