defmodule AppWeb.Router do
  use AppWeb, :router
  use PhoenixSwagger

  alias App.Repo
  alias App.Clock

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/users", UserController, only: [:index, :create, :show, :update, :delete]
    resources "/clocks", ClockController, only: [:index, :show, :update, :delete]
    post "/clocks/:userID", ClockController, :create
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :app,
      swagger_file: "swagger.json"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
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
