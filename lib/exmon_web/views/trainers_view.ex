defmodule ExmonWeb.TrainersView do
  use ExmonWeb, :view

  alias Exmon.Trainer

  def render("create.json", %{
        trainer: %Trainer{id: id, name: name, email: email, inserted_at: inserted_at}
      }) do
    %{
      message: "Trainer created!",
      trainer: %{
        id: id,
        name: name,
        email: email,
        inserted_at: inserted_at
      }
    }
  end

  def render("show.json", %{
        trainer: %Trainer{id: id, name: name, email: email, inserted_at: inserted_at}
      }) do
    %{
      id: id,
      name: name,
      email: email,
      inserted_at: inserted_at
    }
  end

  def render("update.json", %{
        trainer: %Trainer{id: id, name: name, email: email, inserted_at: inserted_at, updated_at: updated_at}
      }) do
    %{
      message: "Trainer updated!",
      trainer: %{
        id: id,
        name: name,
        email: email,
        inserted_at: inserted_at,
        updated_at: updated_at
      }
    }
  end
end
