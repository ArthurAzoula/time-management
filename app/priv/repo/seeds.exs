# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias App.Repo
alias App.Time.Clock
alias App.Accounts.User
alias App.Time.WorkingTime
alias App.Accounts.Team
alias App.Accounts.UsersTeams
import Timex

defmodule Seeds do
  def run do

    # Insert users

    Repo.insert(%User{
      username: "admin",
      email: "admin@admin.fr",
      password_hash: Bcrypt.hash_pwd_salt("AdminPassword123"),
      role: :admin
    })

    Repo.insert!(%User{
      username: "alton",
      email: "alex.milton@gmail.com",
      password_hash: Bcrypt.hash_pwd_salt("alexmilton123"),
      role: :manager
    })

    Repo.insert!(%User{
      username: "janesm",
      email: "jane.smith@outlook.fr",
      password_hash: Bcrypt.hash_pwd_salt("janesmith123")
    })

    Repo.insert!(%User{
      username: "johnsins",
      email: "john.sins@gmail.com",
      password_hash: Bcrypt.hash_pwd_salt("johnsins123")
    })

    Repo.insert!(%User{
      username: "willi59",
      email: "william.lille@hotmail.fr",
      password_hash: Bcrypt.hash_pwd_salt("williamlille123")

    })

    Repo.insert!(%User{
      username: "julie69",
      email: "julie.nam@outlook.fr",
      password_hash: Bcrypt.hash_pwd_salt("julienam123"),
      role: :manager
    })

    # Insert teams
    Repo.insert!(%Team{
      name: "TEAM-01-02",
      manager_id: 2,
    })

    Repo.insert!(%Team{
      name: "TEAM-02-06",
      manager_id: 6,
    })

    # Team 1
    Repo.insert!(%UsersTeams{
      user_id: 4,
      team_id: 1
    })

    Repo.insert!(%UsersTeams{
      user_id: 3,
      team_id: 1
    })

    # Team 2
    Repo.insert!(%UsersTeams{
      user_id: 5,
      team_id: 2
    })

    Repo.insert!(%UsersTeams{
      user_id: 6,
      team_id: 2
    })

    Repo.insert!(%UsersTeams{
      user_id: 2,
      team_id: 2
    })


    # Insert clocks

    Repo.insert!(%Clock{
      user: 1,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    Repo.insert!(%Clock{
      user: 2,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    Repo.insert!(%Clock{
      user: 3,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    Repo.insert!(%Clock{
      user: 4,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    Repo.insert!(%Clock{
      user: 5,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    Repo.insert!(%Clock{
      user: 6,
      time: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      status: false
    })

    # Generate working times for each user for a week
    start_date = Timex.today()
    generate_working_times(1, start_date)
    generate_working_times(2, start_date)
    generate_working_times(3, start_date)
    generate_working_times(4, start_date)
    generate_working_times(5, start_date)
    generate_working_times(6, start_date)
    IO.puts("Seeds inserted")
  end

  defp generate_working_times(userId, start_date) do
    Enum.each(0..-4, fn day_offset ->
      day = Timex.shift(start_date, days: day_offset)
      morning_start = Timex.to_naive_datetime(Timex.set(day, hour: 9, minute: 0, second: 0))

      morning_end =
        Timex.to_naive_datetime(
          Timex.shift(morning_start, hours: :rand.uniform(4) + 2, minutes: :rand.uniform(60))
        )

      afternoon_start = Timex.to_naive_datetime(Timex.shift(morning_end, hours: 1))

      afternoon_end =
        Timex.to_naive_datetime(
          Timex.shift(afternoon_start, hours: :rand.uniform(4) + 2, minutes: :rand.uniform(60))
        )

      Repo.insert!(%WorkingTime{
        user: userId,
        start: NaiveDateTime.truncate(morning_start, :second),
        end: NaiveDateTime.truncate(morning_end, :second)
      })

      Repo.insert!(%WorkingTime{
        user: userId,
        start: NaiveDateTime.truncate(afternoon_start, :second),
        end: NaiveDateTime.truncate(afternoon_end, :second)
      })
    end)
  end
end

Seeds.run()
