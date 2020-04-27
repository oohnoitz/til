defmodule TilWeb.PostLive.Form do
  use TilWeb, :live_view

  alias Til.Posts
  alias Til.Posts.Post

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, user_id: session["user_id"])}
  end

  def handle_params(_params, _url, %{assigns: %{user_id: nil}} = socket) do
    {:noreply,
     socket
     |> put_flash(:error, "You must be logged in to create a new post.")
     |> push_redirect(to: Routes.pow_session_path(socket, :new))}
  end

  @impl true
  def handle_params(params, _url, %{assigns: %{live_action: action}} = socket) do
    {:noreply, apply_action(socket, action, params)}
  end

  defp apply_action(socket, :edit, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)

    cond do
      post.user_id == socket.assigns.user_id ->
        socket
        |> assign(:page_title, "Edit Post")
        |> assign(:post, post)

      true ->
        socket
        |> put_flash(:error, "You do not have permission to edit this post.")
        |> push_redirect(to: Routes.post_show_path(socket, :show, post))
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end
end
