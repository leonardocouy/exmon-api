defmodule ExmonApi.Repo do
  use Ecto.Repo,
    otp_app: :exmon_api,
    adapter: Ecto.Adapters.Postgres
end
