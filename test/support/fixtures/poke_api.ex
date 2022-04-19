defmodule Exmon.Fixtures.PokeApi do
  def pokemon do
    %{
      "id" => 25,
      "name" => "pikachu",
      "types" => [
        %{
          "slot" => 1,
          "type" => %{
            "name" => "electric",
            "url" => "https://pokeapi.co/api/v2/type/13/"
          }
        }
      ],
      "weight" => 60
    }
  end
end
