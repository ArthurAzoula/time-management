defmodule AppWeb.Guardian do
  use Guardian, otp_app: :app

  alias App.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    user_id = claims["sub"]

    case Accounts.get_user!(user_id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
