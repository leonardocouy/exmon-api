defmodule Exmon.Trainer.CreateTest do
  use Exmon.DataCase

  alias Exmon.{Repo, Trainer}
  alias Trainer.Create

  describe "call/1" do
    test "when given params are valid, creates a trainer" do
      params = %{
        name: "Trainer",
        email: "trainer@exmon.com",
        password: "123456"
      }

      count_before = Repo.aggregate(Trainer, :count)
      response = Create.call(params)
      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{email: "trainer@exmon.com"}} = response
      assert count_after > count_before
    end

    test "when given params are invalid, returns the error" do
      params = %{}

      response = Create.call(params)

      assert {:error, changeset} = response
      refute changeset.valid?
    end
  end
end
