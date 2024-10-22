defmodule AppWeb.UserView do
  use AppWeb, :view
  alias AppWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username, email: user.email}
  end

  def render("user_by_manager.json", %{user: user}) do
    %{
      user_id: user.user_id,
      username: user.username,
      email: user.email,
      team_id: user.team_id,
      team_name: user.team_name
    }
  end

  def render("error.json", %{error: error}) do
    %{errors: %{detail: error}}
  end
end
