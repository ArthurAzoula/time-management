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
      name: team.name,
      manager: render_one(team.manager, AppWeb.UserView, "user.json"),
    }
  end

  def render("users_by_manager.json", %{users: grouped_users}) do
    %{data: render_teams(grouped_users)}
  end

  defp render_teams(grouped_users) do
    Enum.map(grouped_users, fn {team_id, members} ->
      %{
        team: %{
          id: team_id,
          name: Enum.at(members, 0).team_name,
          members: render_many(members, AppWeb.TeamView, "user_member.json", as: :user)
        }
      }
    end)
  end


  def render("user_member.json", %{user: user}) do
    %{
      user_id: user.user_id,
      username: user.username,
      email: user.email
    }
  end

end
