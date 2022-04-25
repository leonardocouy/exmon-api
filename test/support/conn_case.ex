defmodule ExmonWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExmonWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExmonWeb.ConnCase

      alias ExmonWeb.Router.Helpers, as: Routes

      import ExmonWeb.ConnCaseHelper

      # The default endpoint for testing
      @endpoint ExmonWeb.Endpoint
    end
  end

  setup tags do
    Exmon.DataCase.setup_sandbox(tags)

    Phoenix.ConnTest.build_conn()
    |> Plug.Conn.put_req_header("accept", "application/json")
    |> build_setup_data(tags)
  end

  defp build_setup_data(conn, tags) when is_map_key(tags, :with_authenticated_user) do
    import ExmonWeb.Auth.Guardian

    trainer = create_trainer()
    {:ok, token, _claims} = encode_and_sign(trainer)

    conn = conn |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn, trainer: trainer}
  end

  defp build_setup_data(conn, _tags), do: {:ok, conn: conn, trainer: nil}

  defp create_trainer do
    {:ok, trainer} =
      Exmon.create_trainer(%{name: "Trainer", email: "trainer@exmon.com", password: "123456"})

    trainer
  end
end
