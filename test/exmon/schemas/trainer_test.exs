defmodule Exmon.TrainerTest do
  use Exmon.ModelCase

  alias Exmon.{Trainer, Repo}
  alias Exmon.Trainer.Create

  describe "build/1" do
    test "when given params are valid, builds struct successfully" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: "123456"
      }

      {:ok, trainer} = Trainer.build(params)

      assert %Trainer{name: "Trainer", email: "trainer@exmon.com", password: "123456"} = trainer
      assert trainer.password_hash != nil
    end

    test "when given params are invalid, returns error" do
      params = %{}

      {:error, _} = Trainer.build(params)

      assert {:error, _} = Trainer.build(params)
    end
  end

  describe "changeset/1" do
    test "when given params is valid, returns a valid changeset" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: "123456"
      }

      changeset = Trainer.changeset(params)

      assert changeset.valid?
      assert changeset.changes.password_hash != nil
    end

    test "when given params contains email with extra spaces and uppercase chars, sanitize and returns a valid changeset" do
      params = %{
        name: "Trainer",
        email: " TRAiner@exmon.com   ",
        password: "123456"
      }

      changeset = Trainer.changeset(params)

      assert changeset.valid?
      assert changeset.changes.email == "trainer@exmon.com"
    end

    test "when given name is not present in the params, returns an invalid changeset" do
      params = %{
        name: nil,
        email: "trainer@exmon.com",
        password: "123456"
      }

      (%{errors: errors} = changeset) = Trainer.changeset(params)

      refute changeset.valid?
      assert [name: {"can't be blank", _}] = errors
    end

    test "when given email is not present in the params, returns an invalid changeset" do
      params = %{
        name: "Trainer",
        email: nil,
        password: "123456"
      }

      (%{errors: errors} = changeset) = Trainer.changeset(params)

      refute changeset.valid?
      assert [email: {"can't be blank", _}] = errors
    end

    test "when given password is not present in the params, returns an invalid changeset" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: nil
      }

      (%{errors: errors} = changeset) = Trainer.changeset(params)

      refute changeset.valid?
      assert [password: {"can't be blank", _}] = errors
    end

    test "when given email is not in a valid format, returns an invalid changeset" do
      params = %{
        name: "Trainer",
        email: "invalid_email",
        password: "123456"
      }

      (%{errors: errors} = changeset) = Trainer.changeset(params)

      refute changeset.valid?
      assert [email: {"has invalid format", _}] = errors
    end

    test "when given password has length less than 6, returns an invalid changeset" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: "123"
      }

      (%{errors: errors} = changeset) = Trainer.changeset(params)

      refute changeset.valid?
      assert [password: {error, _}] = changeset.errors
      assert error =~ ~r/should be at least/
    end
  end

  describe "changeset/2" do
    test "when a trainer changeset and updated params are given, returns the updated changeset" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: "123456"
      }

      update_params = %{params | name: "Updated Trainer"}
      {:ok, existing_trainer} = Create.call(params)

      changeset = Trainer.changeset(existing_trainer, update_params)

      assert changeset.valid?
      assert changeset.changes == %{name: "Updated Trainer"}
    end
  end
end
