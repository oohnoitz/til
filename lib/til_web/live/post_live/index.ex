defmodule TilWeb.PostLive.Index do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Posts.subscribe()

    socket
    |> assign(user_id: session["user_id"])
    |> LiveHelpers.ok(temporary_assigns: [posts: []])
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket
    |> apply_action(socket.assigns.live_action, params)
    |> assign_posts
    |> LiveHelpers.noreply()
  end

  @impl true
  def handle_info({:post_created, post}, %{assigns: %{page: page}} = socket) when page == 1 do
    socket
    |> update(:page_update, fn _ -> :prepend end)
    |> update(:posts, fn posts -> [post | posts] end)
    |> LiveHelpers.noreply()
  end

  @impl true
  def handle_info({:post_deleted, _}, socket) do
    socket
    |> assign_posts()
    |> LiveHelpers.noreply()
  end

  @impl true
  def handle_info({:post_created, _}, socket) do
    LiveHelpers.noreply(socket)
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    send_update(TilWeb.PostLive.PostComponent,
      id: post.id,
      post: post,
      user_id: socket.assigns.user_id
    )

    LiveHelpers.noreply(socket)
  end

  defp apply_action(socket, :index, params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page = if page < 1, do: 1, else: page

    socket
    |> assign(page: page)
    |> assign(page_title: "0x0")
    |> assign(page_update: :replace)
  end

  defp assign_posts(socket) do
    assign(socket, posts: Posts.list_posts(socket.assigns.page))
  end
end
