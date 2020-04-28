defmodule TilWeb.PostController do
  use TilWeb, :controller

  alias Til.Posts

  plug :fetch_random

  def random(%{assigns: %{post: post}} = conn, _params) do
    live_render(conn, TilWeb.PostLive.Show,
      session: %{
        "post_id" => post.id,
        "user_id" => get_session(conn, :user_id)
      }
    )
  end

  defp fetch_random(conn, _opts) do
    case Posts.get_random_post() do
      nil ->
        conn
        |> render("404.html")
        |> halt()

      post ->
        assign(conn, :post, post)
    end
  end
end
