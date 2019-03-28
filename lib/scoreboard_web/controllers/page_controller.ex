defmodule ScoreboardWeb.PageController do
  use ScoreboardWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
