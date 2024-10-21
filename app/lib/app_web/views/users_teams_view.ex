defmodule AppWeb.UsersTeamsView do
  use AppWeb, :view
  alias AppWeb.UsersTeamsView

  def render("index.json", %{users_teams: users_teams}) do
    %{data: render_many(users_teams, UsersTeamsView, "users_teams.json")}
  end

  def render("show.json", %{users_teams: users_teams}) do
    %{data: render_one(users_teams, UsersTeamsView, "users_teams.json")}
  end

  def render("users_teams.json", %{users_teams: users_teams}) do
    %{id: users_teams.id}
  end
end
