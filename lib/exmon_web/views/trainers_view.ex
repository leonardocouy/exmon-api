defmodule ExmonWeb.TrainersView do
  use ExmonWeb, :view

  alias Exmon.Trainer

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
end
