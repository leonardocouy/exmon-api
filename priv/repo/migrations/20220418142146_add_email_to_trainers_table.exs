defmodule Exmon.Repo.Migrations.AddEmailToTrainersTable do
  use Ecto.Migration

  def change do
    alter table(:trainers) do
      add :email, :string, null: false
    end

    create unique_index(:trainers, [:email])
  end
end
