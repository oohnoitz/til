defmodule TilWeb.API.MeController do
  use TilWeb, :controller

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end
end
