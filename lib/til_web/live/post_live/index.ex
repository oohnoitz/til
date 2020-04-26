defmodule TilWeb.PostLive.Index do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Posts.subscribe()

    {:ok, assign(socket, posts: fetch_posts()), temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Listing Posts")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    {:ok, _} = Posts.delete_post(post)

    {:noreply, assign(socket, :posts, fetch_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  defp fetch_posts do
    Posts.list_posts()
  end
end
