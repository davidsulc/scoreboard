defmodule ScoreboardWeb.GameSetupController do
  use ScoreboardWeb, :controller

  alias Scoreboard.GameState.State

  # TODO validate changeset w/ live view (e.g. no negative scores, set scores make sense, etc.)

  def index(conn, params) do
    state =
      case params["new_game"] do
        "true" ->
          %State{}

        _ ->
          {:ok, state} = Scoreboard.GameState.state()
          state
      end

    conn
    |> assign(:state, state)
    |> render("index.html")
  end

  def set(conn, %{"game" => params}) do
    {:ok, _} =
      %State{}
      |> Map.merge(to_game_state(params))
      |> Scoreboard.GameState.merge()

    # redirect(conn, to: Routes.scorekeeper_path(conn, :index))
    # TODO Routes path
    redirect(conn, to: "/scorekeeper")
  end

  # TODO improve state conversion
  defp to_game_state(params) do
    {params, sets} = process_sets(params)
    to_game_state(params, %{sets: sets, can_be_switched: true})
  end

  defp to_game_state(%{} = params, state) when map_size(params) == 0 do
    state
  end

  defp to_game_state(%{"invert_display" => invert} = params, state) do
    params
    |> Map.delete("invert_display")
    |> to_game_state(Map.put(state, :invert_display, invert == "true"))
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
    set_scores =
      4..0
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&Map.get(set_params, &1))
      |> Enum.map(fn %{"team_a" => a, "team_b" => b} ->
        {a, b}
      end)
      |> Enum.filter(fn {a, b} ->
        String.match?(a, ~r/^\d+$/) && String.match?(b, ~r/^\d+$/)
      end)
      |> Enum.map(fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end)

    {
      Map.delete(params, "sets"),
      set_scores
    }
  end
end
