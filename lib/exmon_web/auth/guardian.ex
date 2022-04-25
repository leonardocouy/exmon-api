defmodule ExmonWeb.Auth.Guardian do
  alias Exmon.{Repo, Trainer}

  use Guardian, otp_app: :exmon

  def subject_for_token(trainer, _claims) do
    sub = to_string(trainer.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> Exmon.fetch_trainer()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(Trainer, email: email) do
      nil -> {:error, {:not_found, "Trainer not found!"}}
      trainer -> validate_password(trainer, password)
    end
  end

  def validate_password(%Trainer{password_hash: hash} = trainer, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(trainer)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(trainer) do
    {:ok, token, claims} = encode_and_sign(trainer)
    {:ok, token}
  end
end
