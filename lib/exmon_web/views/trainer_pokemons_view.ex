defmodule ExmonWeb.TrainerPokemonsView do
  use ExmonWeb, :view

  alias Exmon.Trainer.Pokemon

  def render("create.json", %{
        pokemon: %Pokemon{
          id: id,
          name: name,
          weight: weight,
          types: types,
          nickname: nickname,
          trainer_id: trainer_id,
          inserted_at: inserted_at
        }
      }) do
    %{
      message: "Pokemon created!",
      trainer: %{
        id: id,
        name: name,
        weight: weight,
        types: types,
        nickname: nickname,
        trainer_id: trainer_id,
        inserted_at: inserted_at
      }
    }
  end
end
