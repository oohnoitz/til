defmodule TilWeb.TagLive.Show do
  use TilWeb, :live_view

  alias Til.Posts
  alias Til.Tags

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Posts.subscribe()

    {:ok, assign(socket, page: 1, page_update: :prepend, user_id: session["user_id"]),
     temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_params(%{"tag" => tag_name} = params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    page = if page < 1, do: 1, else: page

    tag = Tags.get_tag_by_name!(tag_name)

    {:noreply,
     socket
     |> assign(page: page)
     |> assign(page_title: tag.name)
     |> assign(page_update: :replace)
     |> assign(tag: tag)
     |> fetch_posts()}
  end

  @impl true
  def handle_info({:post_created, _}, socket) do
    {:noreply, socket}
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
    assign(socket, posts: Posts.list_posts_by_tag(socket.assigns.tag.id, socket.assigns.page))
  end
end
