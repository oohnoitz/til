defmodule TilWeb.FallbackController do
  use TilWeb, :controller

  def call(conn, :not_found) do
    conn
    |> put_status(404)
    |> put_view(TilWeb.ErrorView)
    |> render("404.html")
  end
end
