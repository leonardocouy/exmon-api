defmodule Exmon.Trainer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Exmon.Trainer.Pokemon

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "trainers" do
    field :name, :string
    field :password_hash, :string
    field :email, :string

    field :password, :string, virtual: true

    has_many(:pokemons, Pokemon)

    timestamps()
  end

  @required_params [:name, :password, :email]

  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  def changeset(trainer, params), do: create_changeset(trainer, params)

  defp create_changeset(module_or_trainer, params) do
    module_or_trainer
    |> cast(params, @required_params)
    |> update_change(:email, &sanitize_email/1)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email, message: "Email already exists")
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp sanitize_email(str) do
    str
    |> String.trim()
    |> String.downcase()
  end
end
