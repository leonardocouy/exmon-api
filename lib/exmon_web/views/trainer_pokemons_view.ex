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
      pokemon: %{
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

  def render("show.json", %{
    pokemon: %Pokemon{
      id: id,
      name: name,
      weight: weight,
      types: types,
      nickname: nickname,
      trainer_id: trainer_id,
      inserted_at: inserted_at,
      trainer: %{
        id: trainer_id,
        name: trainer_name,
      }
    }
  }) do
    %{
      id: id,
      name: name,
      nickname: nickname,
      weight: weight,
      types: types,
      inserted_at: inserted_at,
      trainer: %{
        id: trainer_id,
        name: trainer_name,
      }
    }
  end

  def render("update.json", %{
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
      message: "Pokemon updated!",
      pokemon: %{
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
