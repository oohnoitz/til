defmodule TilWeb.AuthorLive.Show do
  use TilWeb, :live_view

  alias Til.Posts
  alias Til.Users

  @impl true
  def mount(%{"name" => name}, session, socket) do
    if connected?(socket), do: Posts.subscribe()

    user = Users.get_user_by_name!(name)

    socket
    |> assign(user: user)
    |> assign(user_id: session["user_id"])
    |> ok(temporary_assigns: [posts: []])
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket
    |> apply_action(socket.assigns.live_action, params)
    |> assign_posts
    |> noreply()
  end

  @impl true
  def handle_info({:post_created, _}, socket) do
    noreply(socket)
  end

  @impl true
  def handle_info({:post_deleted, _}, socket) do
    socket
    |> assign_posts()
    |> noreply()
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    send_update(TilWeb.PostLive.PostComponent,
      id: post.id,
      post: post,
      user_id: socket.assigns.user_id
    )

    noreply(socket)
  end

  defp apply_action(socket, :show, params) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page = if page < 1, do: 1, else: page

    socket
    |> assign(page: page)
    |> assign(page_title: socket.assigns.user.name)
    |> assign(page_update: :replace)
  end

  defp assign_posts(socket) do
    assign(socket, posts: Posts.list_posts_by_user(socket.assigns.user.id, socket.assigns.page))
  end
end
