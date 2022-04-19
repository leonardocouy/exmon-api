defmodule ExmonWeb.PokemonsRequestTest do
  use ExmonWeb.ConnCase, async: true
  alias Exmon.Fixtures
  import Tesla.Mock

  @base_poke_api_url "https://pokeapi.co/api/v2/pokemon/"

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "GET /pokemons/:id" do
    test "when the pokemon exists, returns the pokemon data", %{conn: conn} do
      mock(fn %{method: :get, url: @base_poke_api_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: Fixtures.PokeApi.pokemon()}
      end)

      result = get(conn, Routes.pokemons_path(conn, :show, "pikachu"))

      assert result.status == 200

      assert %{
               "id" => _id,
               "name" => "pikachu",
               "types" => ["electric"],
               "weight" => 60
             } = json_response(result, 200)
    end

    test "when the pokemon does not exist, returns 404", %{conn: conn} do
      mock(fn %{method: :get, url: @base_poke_api_url <> "invalid_pokemon"} ->
        %Tesla.Env{status: 404}
      end)

      result = get(conn, Routes.pokemons_path(conn, :show, "invalid_pokemon"))

      assert result.status == 404
    end

    test "when pokeapi raise an unexpected error, returns 400", %{conn: conn} do
      mock(fn %{method: :get, url: @base_poke_api_url <> "pikachu"} ->
        {:error, :timeout}
      end)

      result = get(conn, Routes.pokemons_path(conn, :show, "pikachu"))

      assert result.status == 400
      assert json_response(result, 400) == %{"message" => "timeout"}
    end
  end
end
