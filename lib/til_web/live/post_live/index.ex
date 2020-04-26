defmodule TilWeb.PostLive.Index do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Posts.subscribe()

    {:ok, assign(socket, page: 1, page_update: :prepend), temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")

    {:noreply,
     socket
     |> assign(page_title: "Listing Posts", page: page)
     |> assign(page_update: :replace)
     |> fetch_posts()}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    {:ok, _} = Posts.delete_post(post)

    {:noreply, fetch_posts(socket)}
  end

  @impl true
  def handle_info({:post_created, post}, %{assigns: %{page: page}} = socket) when page == 1 do
    {:noreply,
     socket
     |> update(:page_update, fn _ -> :prepend end)
     |> update(:posts, fn posts -> [post | posts] end)}
  end

  def handle_info({:post_created, _}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    send_update(TilWeb.PostLive.PostComponent, id: post.id, post: post)
    {:noreply, socket}
  end

  defp fetch_posts(socket) do
    assign(socket, posts: Posts.list_posts(socket.assigns.page))
  end
end
