defmodule AppWeb.Router do
  use AppWeb, :router
  use PhoenixSwagger

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/users", UserController , only: [:index, :create, :show, :update, :delete]
    resources "/workingtime", WorkingTimeController, only: [:index, :create, :show, :update, :delete]
    post "/workingtime/:userID", WorkingTimeController, :create
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :app,
      swagger_file: "swagger.json"
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  def swagger_info do
    %{
      schemes: ["http"],
      info: %{
        title: "Time management private API",
        version: "0.1.0",
        description: "This is a private API for Epitech students to manage their time",
      },
      definitions: AppWeb.SwaggerSchema.swagger_definitions()
    }
  end
end
