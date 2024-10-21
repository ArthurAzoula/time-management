defmodule AppWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :app,
    module: AppWeb.Guardian,
    error_handler: AppWeb.Guardian.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule AppWeb.RolePipeline do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, roles) do
    user = Guardian.Plug.current_resource(conn)

    IO.inspect(user, label: "Current User")

    roles_as_atoms = Enum.map(roles, &String.to_atom/1)

    if user && user.role in roles_as_atoms do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Forbidden"})
      |> halt()
    end
  end
end
