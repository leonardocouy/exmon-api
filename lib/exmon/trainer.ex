defmodule Exmon.Trainer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "trainers" do
    field :name, :string
    field :password_hash, :string
    field :email, :string
    timestamps()
  end

  @required_params [:name, :password_hash, :email]
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> update_change(:email, &sanitize_email/1)
    |> validate_required(@required_params)
    |> validate_length(:password_hash, min: 6)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp sanitize_email(str) do
    str
      |> String.trim()
      |> String.downcase()
  end
end
