defmodule Exmon.Repo.Migrations.AddPokemonsTable do
  use Ecto.Migration

  def change do
    create table(:pokemons, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :nickname, :string, null: false
      add :weight, :integer, null: false
      add :types, {:array, :string}, null: false
      add :trainer_id, references(:trainers, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
