defmodule Exmon.Trainer.Create do
  alias Exmon.{Repo, Trainer}

  def call(params) do
    params
    |> Trainer.changeset()
    |> Repo.insert()
    |> handle_result
  end

  defp handle_result({:ok, struct}), do: {:ok, struct}
  defp handle_result({:error, _changeset} = error), do: error
end
