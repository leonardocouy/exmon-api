defmodule ExmonWeb.WelcomeController do
  use ExmonWeb, :controller

  def index(conn, _params) do
    text(conn, "Welcome to the ExMon API")
  end
end
