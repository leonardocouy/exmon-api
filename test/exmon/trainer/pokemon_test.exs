defmodule Exmon.Trainer.PokemonTest do
  use Exmon.DataCase

  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon

  describe "build/1" do
    test "when given params are valid, builds struct successfully" do
      %{id: trainer_id} = create_trainer()

      params = %{
        name: "Pikachu",
        nickname: "Electric Rat",
        weight: 60,
        types: ["eletric"],
        trainer_id: trainer_id
      }

      {:ok, trainer_pokemon} = TrainerPokemon.build(params)

      assert %TrainerPokemon{
               id: _id,
               name: "Pikachu",
               nickname: "Electric Rat",
               weight: 60,
               types: ["eletric"],
               trainer_id: ^trainer_id
             } = trainer_pokemon
    end

    test "when given params are invalid, returns error" do
      params = %{}

      assert {:error, %Ecto.Changeset{valid?: false}} = TrainerPokemon.build(params)
    end
  end

  describe "changeset/1" do
    test "when given params is valid, returns a valid changeset" do
      params = %{
        name: "Pikachu",
        nickname: "Electric Rat",
        weight: 60,
        types: ["eletric"],
        trainer_id: Ecto.UUID.generate()
      }

      changeset = TrainerPokemon.changeset(params)

      assert changeset.valid?

      assert %{
               name: "Pikachu",
               nickname: "Electric Rat",
               weight: 60,
               types: ["eletric"],
               trainer_id: _trainer_id
             } = changeset.changes
    end

    @required_params [:name, :nickname, :weight, :types, :trainer_id]
    Enum.each(@required_params, fn required_param_name ->
      @required_param_name required_param_name

      test "when given #{required_param_name} is not present in the params, returns an invalid changeset" do
        params = %{
          name: "Pikachu",
          nickname: "Electric Rat",
          weight: 60,
          types: ["eletric"],
          trainer_id: Ecto.UUID.generate()
        }

        changeset = TrainerPokemon.changeset(%{params | @required_param_name => nil})

        refute changeset.valid?
        assert errors_on(changeset) == %{@required_param_name => ["can't be blank"]}
      end
    end)

    test "when given nickname has length less than 2, returns an invalid changeset" do
      params = %{
        name: "Pikachu",
        nickname: "x",
        weight: 60,
        types: ["eletric"],
        trainer_id: Ecto.UUID.generate()
      }

      changeset = TrainerPokemon.changeset(params)

      refute changeset.valid?
      assert errors_on(changeset) == %{nickname: ["should be at least 2 character(s)"]}
    end
  end

  describe "update_changeset/2" do
    test "when given params is valid, returns a valid changeset containing only the valid changes" do
      %{id: trainer_id} = create_trainer()

      params = %{
        name: "Pikachu",
        nickname: "Eletric Rat",
        weight: 60,
        types: ["eletric"],
        trainer_id: trainer_id
      }

      update_params = %{params | nickname: "Updated Nickname", weight: 49}
      {:ok, existing_trainer_pokemon} = TrainerPokemon.changeset(params) |> Repo.insert()

      changeset = TrainerPokemon.update_changeset(existing_trainer_pokemon, update_params)

      assert changeset.valid?

      assert %Ecto.Changeset{
               changes: %{
                 nickname: "Updated Nickname"
               },
               data: %TrainerPokemon{
                 id: _id,
                 nickname: "Eletric Rat",
                 weight: 60,
                 types: ["eletric"],
                 trainer_id: _trainer_id
               }
             } = changeset
    end

    @required_params [:nickname]
    Enum.each(@required_params, fn required_param_name ->
      @required_param_name required_param_name

      test "when given #{required_param_name} is not present in the params, returns an invalid changeset" do
        params = %{
          name: "Pikachu",
          nickname: "Eletric Rat",
          weight: 60,
          types: ["eletric"],
          trainer_id: Ecto.UUID.generate()
        }

        existing_trainer_pokemon_changeset = TrainerPokemon.changeset(params)
        update_params = %{params | @required_param_name => nil}

        changeset =
          TrainerPokemon.update_changeset(existing_trainer_pokemon_changeset, update_params)

        refute changeset.valid?
        assert errors_on(changeset) == %{@required_param_name => ["can't be blank"]}
      end
    end)

    test "when given nickname has length less than 2, returns an invalid changeset" do
      params = %{
        name: "Pikachu",
        nickname: "Eletric Rat",
        weight: 60,
        types: ["eletric"],
        trainer_id: Ecto.UUID.generate()
      }

      existing_trainer_pokemon_changeset = TrainerPokemon.changeset(params)
      update_params = %{params | nickname: "x"}

      changeset =
        TrainerPokemon.update_changeset(existing_trainer_pokemon_changeset, update_params)

      refute changeset.valid?
      assert errors_on(changeset) == %{nickname: ["should be at least 2 character(s)"]}
    end
  end

  defp create_trainer do
    {:ok, trainer} =
      Exmon.create_trainer(%{name: "Trainer", email: "trainer@exmon.com", password: "123456"})

    trainer
  end
end
