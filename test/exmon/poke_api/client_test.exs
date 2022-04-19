defmodule Exmon.PokeApi.ClientTest do
  use ExUnit.Case
  alias Exmon.Fixtures
  alias Exmon.PokeApi.Client
  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "get_pokemon/1" do
    test "when there is a pokemon with the given name, returns the pokemon" do
      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: Fixtures.PokeApi.pokemon()}
      end)

      response = Client.get_pokemon("pikachu")

      assert {:ok,
              %{
                "name" => "pikachu",
                "weight" => 60,
                "types" => ["electric"]
              }} = response
    end

    test "when there is no pokemon with the given name, returns the error" do
      mock(fn %{method: :get, url: @base_url <> "invalid_pokemon"} ->
        %Tesla.Env{status: 404}
      end)

      response = Client.get_pokemon("invalid_pokemon")

      assert {:error, :not_found} = response
    end

    test "when there is an unexpected error, returns the error" do
      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        {:error, :timeout}
      end)

      response = Client.get_pokemon("pikachu")

      assert {:error, :timeout} = response
    end
  end
end
