defmodule TilWeb.PostLive.PostComponent do
  use TilWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <article id="post-<%= @post.id %>" class="max-w-3xl rounded overflow-hidden shadow-lg m-auto mt-5">
      <div class="px-6 py-4">
        <%= live_redirect @post.title, to: Routes.post_show_path(@socket, :show, @post), class: "font-bold text-3xl mb-2" %>

        <div class="text-gray-700 text-base pt-5" phx-hook="CodeHighlight">
          <%= raw Til.Markdown.to_html(@post.body) %>
        </div>

        <div class="flex items-center pt-5">
          <img class="w-10 h-10 rounded-full mr-4" src="https://picsum.photos/200" alt="Avatar of Jonathan Reinink">
          <div class="text-sm">
            <p class="text-gray-900 leading-none"><%= @post.user.name %></p>
            <p class="text-gray-600"><%= @post.inserted_at %></p>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3">
        <%= live_redirect "##{@post.tag.name}",
          to: "#",
          class: "text-gray-700 text-center border-t-2 px-4 py-2 m-2 uppercase"
        %>
        <%= live_redirect "Permalink",
          to: Routes.post_show_path(@socket, :show, @post),
          class: "text-gray-700 text-center border-t-2 px-4 py-2 m-2 uppercase"
        %>
        <button class="text-gray-700 text-center border-t-2 px-4 py-2 m-2" type="button" phx-click="like" phx-target="<%= @myself %>">
          <div class="flex items-center justify-center">
            <gg-icon class="gg-heart"></gg-icon>
            <span class="pl-3"><%= @post.likes %></span>
          </div>
        </button>
      </div>
    </article>
    """
  end

  @impl true
  def handle_event("like", _, socket) do
    Til.Posts.increment_likes(socket.assigns.post)

    {:noreply, socket}
  end
end
