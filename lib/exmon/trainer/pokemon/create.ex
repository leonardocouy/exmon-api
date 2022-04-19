defmodule Exmon.Trainer.Pokemon.Create do
  alias Exmon.PokeApi.Client
  alias Exmon.{Pokemon, Repo}
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon

  def call(%{"name" => name} = params) do
    name
    |> Client.get_pokemon()
    |> handle_response(params)
  end

  defp handle_response({:ok, body}, params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  defp handle_response({:error, _msg} = error, _params), do: error

  defp create_pokemon(
         %Pokemon{name: name, weight: weight, types: types},
         %{"nickname" => nickname, "trainer_id" => trainer_id}
       ) do
    params = %{
      name: name,
      weight: weight,
      types: types,
      nickname: nickname,
      trainer_id: trainer_id
    }

    params
    |> TrainerPokemon.build()
    |> persist
  end

  defp persist({:ok, pokemon}), do: Repo.insert(pokemon)
  defp persist({:error, _changeset} = error), do: error
end
