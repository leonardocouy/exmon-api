defmodule ExmonWeb.TrainerPokemonsRequestTest do
  use ExmonWeb.ConnCase, async: true
  alias Exmon.Fixtures
  alias Exmon.Repo
  alias Exmon.Trainer.Pokemon, as: TrainerPokemon

  import Tesla.Mock

  @base_poke_api_url "https://pokeapi.co/api/v2/pokemon/"

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "POST /trainer_pokemons" do
    test "when params is valid, returns the created trainer with 201", %{conn: conn} do
      %{id: trainer_id} = create_trainer()

      params = %{
        name: "pikachu",
        nickname: "Eletric Rat",
        trainer_id: trainer_id
      }

      mock(fn %{method: :get, url: @base_poke_api_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: Fixtures.PokeApi.pokemon()}
      end)

      result = post(conn, Routes.trainer_pokemons_path(conn, :create), params)

      assert result.status == 201

      assert %{
               "message" => "Pokemon created!",
               "pokemon" => %{
                 "id" => _id,
                 "nickname" => "Eletric Rat",
                 "weight" => 60,
                 "types" => ["electric"],
                 "trainer_id" => _trainer_id
               }
             } = json_response(result, 201)
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn} do
      params = %{name: "invalid_pokemon"}

      mock(fn %{method: :get, url: @base_poke_api_url <> "invalid_pokemon"} ->
        {:error, :timeout}
      end)

      result = post(conn, Routes.trainer_pokemons_path(conn, :create), params)

      assert result.status == 400
      assert json_response(result, 400) != %{}
    end
  end

  describe "GET /trainer_pokemons/:id" do
    test "when the trainer pokemon exists, returns the trainer pokemon data", %{conn: conn} do
      %{id: id, trainer_id: trainer_id} = create_trainer_pokemon()
      result = get(conn, Routes.trainer_pokemons_path(conn, :show, id))

      assert result.status == 200

      assert %{
               "id" => ^id,
               "name" => "Pikachu",
               "nickname" => "Eletric Rat",
               "weight" => 60,
               "types" => ["eletric"],
               "trainer" => %{"id" => ^trainer_id, "name" => _name}
             } = json_response(result, 200)
    end

    test "when the trainer pokemon does not exist, returns 404", %{conn: conn} do
      result = get(conn, Routes.trainer_pokemons_path(conn, :show, Ecto.UUID.generate()))

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer Pokemon not found!"
             } = result
    end
  end

  describe "PUT /trainers/:id" do
    test "when the trainer pokemon exists and the params are valid, returns the updated trainer pokemon data",
         %{
           conn: conn
         } do
      (%{id: id} = trainer_pokemon) = create_trainer_pokemon()
      update_params = Map.from_struct(trainer_pokemon) |> Map.put(:nickname, "Updated Nickname")

      result = put(conn, Routes.trainer_pokemons_path(conn, :update, id), update_params)
      (%{"pokemon" => updated_trainer_pokemon} = response) = json_response(result, 200)

      assert result.status == 200

      assert %{
               "message" => "Pokemon updated!",
               "pokemon" => %{"id" => ^id, "nickname" => "Updated Nickname"}
             } = response

      assert updated_trainer_pokemon["updated_at"] >=
               trainer_pokemon.updated_at |> NaiveDateTime.to_iso8601()
    end

    test "when the trainer pokemon exists and the params are invalid, returns bad request with errors",
         %{
           conn: conn
         } do
      %{id: id} = create_trainer_pokemon()
      update_params = %{nickname: "x"}

      result = put(conn, Routes.trainer_pokemons_path(conn, :update, id), update_params)

      assert result.status == 400
      assert json_response(result, 400) != %{}
    end

    test "when the trainer does not exist, returns 404", %{conn: conn} do
      update_params = %{}

      result =
        put(
          conn,
          Routes.trainer_pokemons_path(conn, :update, Ecto.UUID.generate()),
          update_params
        )

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer Pokemon not found!"
             } = result
    end
  end

  describe "DELETE /trainer_pokemons/:id" do
    test "when the trainer pokemon exists, returns the trainer pokemon data", %{conn: conn} do
      %{id: id} = create_trainer_pokemon()

      result = delete(conn, Routes.trainer_pokemons_path(conn, :show, id))

      assert result.status == 204
    end

    test "when the trainer pokemons does not exist, returns 404", %{conn: conn} do
      result = delete(conn, Routes.trainer_pokemons_path(conn, :show, Ecto.UUID.generate()))

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer Pokemon not found!"
             } = result
    end
  end

  defp create_trainer_pokemon do
    %{id: trainer_id} = create_trainer()

    {:ok, trainer_pokemon} =
      TrainerPokemon.changeset(%{
        name: "Pikachu",
        nickname: "Eletric Rat",
        weight: 60,
        types: ["eletric"],
        trainer_id: trainer_id
      })
      |> Repo.insert()

    trainer_pokemon
  end

  defp create_trainer do
    {:ok, trainer} =
      Exmon.create_trainer(%{name: "Trainer", email: "trainer@exmon.com", password: "123456"})

    trainer
  end
end
