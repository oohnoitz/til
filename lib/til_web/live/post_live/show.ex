defmodule TilWeb.PostLive.Show do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, %{"post_id" => post_id}, socket) do
    post = Posts.get_post!(post_id)

    if connected?(socket), do: Posts.subscribe("post:#{post.id}")

    {:ok,
     socket
     |> assign(:post, post)
     |> apply_title(socket.assigns.live_action)}
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    post = Posts.get_post_by_slug!(slug)

    if connected?(socket), do: Posts.subscribe("post:#{post.id}")

    {:ok,
     socket
     |> assign(:post, post)
     |> apply_title(socket.assigns.live_action)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :post, fn _ -> post end)}
  end

  defp apply_title(socket, :show) do
    socket
    |> assign(:page_title, socket.assigns.post.title)
    |> assign(:title, page_title(:show))
  end

  defp apply_title(socket, :edit) do
    socket
    |> assign(:page_title, page_title(:edit))
    |> assign(:title, page_title(:edit))
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
