defmodule Exmon.Trainer.Update do
  alias Ecto.UUID
  alias Exmon.{Repo, Trainer}

  def call(%{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, "Invalid UUID"}
      {:ok, _uuid} -> update(fetch_trainer(uuid), params)
    end
  end

  defp update(trainer, _params) when trainer == nil, do: {:error, "Trainer not found!"}
  defp update(trainer, params), do: update_trainer(trainer, params)

  defp fetch_trainer(uuid), do: Repo.get(Trainer, uuid)

  defp update_trainer(trainer, params) do
    trainer
    |> Trainer.changeset(params)
    |> Repo.update()
  end
end
