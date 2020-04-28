defmodule TilWeb.PostController do
  use TilWeb, :controller

  alias Til.Posts

  def random(conn, _params) do
    post = Posts.get_random_post()

    live_render(conn, TilWeb.PostLive.Show,
      session: %{
        "post_id" => post.id,
        "user_id" => get_session(conn, :user_id)
      }
    )
  end
end
