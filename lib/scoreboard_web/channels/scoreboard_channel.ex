defmodule ScoreboardWeb.ScoreboardChannel do
  use ScoreboardWeb, :channel

  def join("scoreboard:lobby", _payload, socket), do: {:ok, socket}

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (scoreboard:lobby).
  def handle_in("update", payload, socket) do
    broadcast socket, "update", payload
    {:noreply, socket}
  end
end
