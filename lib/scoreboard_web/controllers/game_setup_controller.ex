defmodule ScoreboardWeb.GameSetupController do
  use ScoreboardWeb, :controller

  # TODO validate changeset w/ live view (e.g. no negative scores, set scores make sense, etc.)

  def index(conn, _params) do
    {:ok, state} = Scoreboard.GameState.state()

    conn
    |> assign(:state, state)
    |> render("index.html")
  end

  def set(conn, %{"game" => params}) do
    params
    |> to_game_state()
    |> Scoreboard.GameState.merge()

    # redirect(conn, to: Routes.scorekeeper_path(conn, :index))
    # TODO Routes path
    redirect(conn, to: "/scorekeeper")
  end

  # TODO improve state conversion
  defp to_game_state(params) do
    {params, set_info} = process_sets(params)
    to_game_state(params, set_info)
  end

  defp to_game_state(%{} = params, state) when map_size(params) == 0 do
    state
  end

  defp to_game_state(%{"team_a" => name} = params, state) do
    params
    |> Map.delete("team_a")
    |> to_game_state(Map.put(state, :team_a, name))
  end

  defp to_game_state(%{"team_b" => name} = params, state) do
    params
    |> Map.delete("team_b")
    |> to_game_state(Map.put(state, :team_b, name))
  end

  defp process_sets(%{"sets" => set_params} = params) do
    [current | rest] =
      4..0
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&Map.get(set_params, &1))
      |> Enum.map(fn %{"a" => a, "b" => b} ->
        {a, b}
      end)
      |> Enum.filter(fn {a, b} ->
        String.match?(a, ~r/^\d+$/) && String.match?(b, ~r/^\d+$/)
      end)
      |> Enum.map(fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end)

    # TODO handle last set -> current set
    {
      Map.delete(params, "sets"),
      %{current_set: current, sets: Enum.reverse(rest)}
    }
  end
end
