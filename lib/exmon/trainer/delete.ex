defmodule Exmon.Trainer.Delete do
  alias Exmon.Repo
  alias Exmon.Trainer.Get

  def call(id) do
    case Get.call(id) do
      {:ok, trainer} -> Repo.delete(trainer)
      {:error, reason} -> {:error, reason}
    end
  end
end
