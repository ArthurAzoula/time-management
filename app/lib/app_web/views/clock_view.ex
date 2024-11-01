defmodule AppWeb.ClockView do
  use AppWeb, :view
  alias AppWeb.ClockView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock.json")}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("clock.json", %{clock: clock}) do
    %{id: clock.id, time: clock.time, status: clock.status, user: clock.user}
  end

  def render("error.json", %{error: error}) do
    %{errors: %{detail: error}}
  end
end
