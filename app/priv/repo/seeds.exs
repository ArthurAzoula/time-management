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
import Timex

defmodule Seeds do
  def run do
    # Insert users
    Repo.insert!(%User{
      id: 1,
      username: "johndoe",
      email: "johndoe@mail.fr"
    })

    Repo.insert!(%User{
      id: 2,
      username: "janedoe",
      email: "janedoe@mail.fr"
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

    # Generate working times for each user for a week
    start_date = Timex.today()
    generate_working_times(1, start_date)
    generate_working_times(2, start_date)
    IO.puts("Seeds inserted")
  end

  defp generate_working_times(userId, start_date) do
    Enum.each(0..4, fn day_offset ->
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
