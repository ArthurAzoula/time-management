defmodule AppWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :app,
    module: AppWeb.Guardian,
    error_handler: AppWeb.Guardian.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
