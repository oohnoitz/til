defmodule TilWeb.PostLive.Index do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Posts.subscribe()

    {:ok, assign(socket, page: 1, page_update: :prepend, user_id: session["user_id"]),
     temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page = if page < 1, do: 1, else: page

    {:noreply,
     socket
     |> assign(page: page)
     |> assign(page_title: "0x0")
     |> assign(page_update: :replace)
     |> fetch_posts()}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)

    if socket.assigns.user_id == post.user_id do
      {:ok, _} = Posts.delete_post(post)

      {:noreply, fetch_posts(socket)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:post_created, post}, %{assigns: %{page: page}} = socket) when page == 1 do
    {:noreply,
     socket
     |> update(:page_update, fn _ -> :prepend end)
     |> update(:posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    send_update(TilWeb.PostLive.PostComponent,
      id: post.id,
      post: post,
      user_id: socket.assigns.user_id
    )

    {:noreply, socket}
  end

  defp fetch_posts(socket) do
    assign(socket, posts: Posts.list_posts(socket.assigns.page))
  end
end
