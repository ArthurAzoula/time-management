defmodule AppWeb.TeamView do
  use AppWeb, :view

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, AppWeb.TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, AppWeb.TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name
    }
  end

  def render("users_by_manager.json", %{users: users}) do
    %{data: render_many(users, AppWeb.UserView, "user_by_manager.json")}
  end
end
