defmodule ExmonWeb.TrainersControllerTest do
  use ExmonWeb.ConnCase, async: true

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "POST /trainers" do
    test "when params is valid, returns the created trainer with 201", %{conn: conn} do
      params = %{name: "Trainer", email: "trainer@exmon.com", password: "123456"}

      result = post(conn, Routes.trainers_path(conn, :create), params)
      (%{"trainer" => created_trainer} = response) = json_response(result, 201)

      assert result.status == 201
      assert %{
        "message" => "Trainer created!",
        "trainer" => %{"name" => "Trainer", "email" => "trainer@exmon.com"}
      } = response
      assert created_trainer["id"] != nil
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn} do
      params = %{}

      result = post(conn, Routes.trainers_path(conn, :create), params)

      assert result.status == 400
      assert json_response(result, 400) != %{}
    end
  end

  describe "GET /trainers/:id" do
    test "when the trainer exists, returns the trainer data", %{conn: conn} do
      %{id: id, name: name, email: email, inserted_at: inserted_at, updated_at: updated_at} =
        create_trainer()

      result = get(conn, Routes.trainers_path(conn, :show, id))

      assert result.status == 200

      assert %{
               "id" => id,
               "name" => name,
               "email" => email,
               "inserted_at" => inserted_at
             } = json_response(result, 200)
    end

    test "when the trainer does not exist, returns 404", %{conn: conn} do
      result = get(conn, Routes.trainers_path(conn, :show, Ecto.UUID.generate()))

      assert result.status == 404
    end
  end

  describe "PUT /trainers/:id" do
    test "when the trainer exists and the params are valid, returns the updated trainer data", %{
      conn: conn
    } do
      (%{id: id} = trainer) = create_trainer()
      update_params = Map.from_struct(trainer) |> Map.put(:name, "Updated Trainer")

      result = put(conn, Routes.trainers_path(conn, :update, id), update_params)
      (%{"trainer" => updated_trainer} = response) = json_response(result, 200)

      assert result.status == 200

      assert %{
               "message" => "Trainer updated!",
               "trainer" => %{"id" => id, "name" => "Updated Trainer"}
             } = response
      assert updated_trainer["updated_at"] >= trainer.updated_at |> NaiveDateTime.to_iso8601
    end

    test "when the trainer exists and the params are invalid, returns bad request with errors", %{
      conn: conn
    } do
      %{id: id} = create_trainer()
      update_params = %{}

      result = put(conn, Routes.trainers_path(conn, :update, id), update_params)

      assert result.status == 400
      assert json_response(result, 400) != %{}
    end

    test "when the trainer does not exist, returns 404", %{conn: conn} do
      update_params = %{}

      result = put(conn, Routes.trainers_path(conn, :update, Ecto.UUID.generate()), update_params)

      assert result.status == 404
    end
  end

  describe "DELETE /trainers/:id" do
    test "when the trainer exists, returns the trainer data", %{conn: conn} do
      %{id: id} = create_trainer()

      result = delete(conn, Routes.trainers_path(conn, :delete, id))

      assert result.status == 204
    end

    test "when the trainer does not exist, returns 404", %{conn: conn} do
      result = delete(conn, Routes.trainers_path(conn, :delete, Ecto.UUID.generate()))

      assert result.status == 404
    end
  end

  defp create_trainer do
    {:ok, trainer} =
      Exmon.create_trainer(%{name: "Trainer", email: "trainer@exmon.com", password: "123456"})

    trainer
  end
end
