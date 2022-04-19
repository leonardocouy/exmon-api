defmodule Exmon.Fixtures.PokeApi do
  def pokemon do
    %{
      "id" => 25,
      "name" => "pikachu",
      "types" => [
        "electric"
      ],
      "weight" => 60
    }
  end
end
