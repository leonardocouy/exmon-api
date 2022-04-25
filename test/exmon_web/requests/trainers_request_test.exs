defmodule ExmonWeb.TrainersRequestTest do
  use ExmonWeb.ConnCase, async: true

  describe "POST /trainers" do
    test "when params is valid, returns the created trainer with 201", %{conn: conn} do
      params = %{name: "Trainer", email: "trainer2@exmon.com", password: "123456"}

      result = post(conn, Routes.trainers_path(conn, :create), params)
      (%{"trainer" => created_trainer} = response) = json_response(result, 201)

      assert result.status == 201

      assert %{
               "message" => "Trainer created!",
               "trainer" => %{"name" => "Trainer", "email" => "trainer2@exmon.com"},
               "token" => _token
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
    @tag :with_authenticated_user
    test "when the trainer exists, returns the trainer data", %{conn: conn, trainer: trainer} do
      %{id: id, email: email} = trainer

      result = get(conn, Routes.trainers_path(conn, :show, id))

      assert result.status == 200

      assert %{
               "id" => ^id,
               "name" => _name,
               "email" => ^email,
               "inserted_at" => _inserted_at
             } = json_response(result, 200)
    end

    @tag :with_authenticated_user
    test "when the trainer does not exist, returns 404", %{conn: conn, trainer: _trainer} do
      result = get(conn, Routes.trainers_path(conn, :show, Ecto.UUID.generate()))

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer not found!"
             } = result
    end
  end

  describe "PUT /trainers/:id" do
    @tag :with_authenticated_user
    test "when the trainer exists and the params are valid, returns the updated trainer data", %{
      conn: conn,
      trainer: trainer
    } do
      %{id: id} = trainer
      update_params = Map.from_struct(trainer) |> Map.put(:name, "Updated Trainer")

      result = put(conn, Routes.trainers_path(conn, :update, id), update_params)
      (%{"trainer" => updated_trainer} = response) = json_response(result, 200)

      assert result.status == 200

      assert %{
               "message" => "Trainer updated!",
               "trainer" => %{"id" => ^id, "name" => "Updated Trainer"}
             } = response

      assert updated_trainer["updated_at"] >= trainer.updated_at |> NaiveDateTime.to_iso8601()
    end

    @tag :with_authenticated_user
    test "when the trainer exists and the params are invalid, returns bad request with errors", %{
      conn: conn,
      trainer: trainer
    } do
      %{id: id} = trainer
      update_params = %{}

      result = put(conn, Routes.trainers_path(conn, :update, id), update_params)

      assert result.status == 400
      assert json_response(result, 400) != %{}
    end

    @tag :with_authenticated_user
    test "when the trainer does not exist, returns 404", %{conn: conn, trainer: _trainer} do
      update_params = %{}

      result = put(conn, Routes.trainers_path(conn, :update, Ecto.UUID.generate()), update_params)

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer not found!"
             } = result
    end
  end

  describe "DELETE /trainers/:id" do
    @tag :with_authenticated_user
    test "when the trainer exists, returns the trainer data", %{conn: conn, trainer: trainer} do
      %{id: id} = trainer

      result = delete(conn, Routes.trainers_path(conn, :delete, id))

      assert result.status == 204
    end

    @tag :with_authenticated_user
    test "when the trainer does not exist, returns 404", %{conn: conn, trainer: _trainer} do
      result = delete(conn, Routes.trainers_path(conn, :delete, Ecto.UUID.generate()))

      assert %Plug.Conn{
               status: 404,
               resp_body: "Trainer not found!"
             } = result
    end
  end
end
