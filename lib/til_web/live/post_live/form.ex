defmodule TilWeb.PostLive.Form do
  use TilWeb, :live_view

  alias Til.Posts
  alias Til.Posts.Post

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, user_id: session["user_id"])}
  end

  @impl true
  def handle_params(params, _url, %{assigns: %{live_action: action}} = socket) do
    {:noreply, apply_action(socket, action, params)}
  end

  defp apply_action(socket, :edit, %{"slug" => slug}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Posts.get_post_by_slug!(slug))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end
end
