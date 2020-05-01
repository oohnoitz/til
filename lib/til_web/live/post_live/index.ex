defmodule TilWeb.PostLive.Index do
  use TilWeb, :live_view

  alias Til.Posts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Posts.subscribe()

    socket
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
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)

    with true <- socket.assigns.user_id == post.user_id,
         {:ok, _} = Posts.delete_post(post) do
      socket
      |> assign_posts()
      |> noreply()
    else
      _ ->
        noreply(socket)
    end
  end

  @impl true
  def handle_info({:post_created, post}, %{assigns: %{page: page}} = socket) when page == 1 do
    socket
    |> update(:page_update, fn _ -> :prepend end)
    |> update(:posts, fn posts -> [post | posts] end)
    |> noreply()
  end

  @impl true
  def handle_info({:post_created, _}, socket) do
    noreply(socket)
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
