defmodule TilWeb.PostLive.PostComponent do
  use TilWeb, :live_component

  alias Til.Posts

  @impl true
  def render(assigns) do
    ~L"""
    <article id="post-<%= @post.id %>" class="max-w-3xl rounded overflow-hidden shadow-lg m-auto mt-5">
      <div class="px-6 py-4">
        <%= live_redirect @post.title, to: Routes.post_show_path(@socket, :show, @post), class: "font-bold text-3xl mb-2" %>

        <%= if @user_id == @post.user_id do %>
          <div class="flex items-center">
            <%= live_redirect to: Routes.post_form_path(@socket, :edit, @post) do %>
              <gg-icon class="gg-pen"></gg-icon>
            <% end %>
            <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, phx_target: @myself, class: "pl-5", data: [confirm: "Are you sure you want to delete this post?"] do %>
              <gg-icon class="gg-trash"></gg-icon>
            <% end %>
          </div>
        <% end %>

        <div class="text-gray-700 text-base pt-5 markdown" phx-hook="CodeHighlight">
          <%= raw Til.Markdown.to_html(@post.body) %>
        </div>

        <div class="flex items-center pt-5">
          <div class="text-sm">
            <p class="text-gray-900 leading-none">
              <%= live_redirect @post.user.name, to: Routes.author_show_path(@socket, :show, @post.user.name) %>
            </p>
            <p class="text-gray-600"><%= @post.inserted_at %></p>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3">
        <%= live_redirect "##{@post.tag.name}",
          to: Routes.tag_show_path(@socket, :show, @post.tag.name),
          class: "text-gray-700 text-center border-t-2 p-2 m-2 uppercase"
        %>
        <%= live_redirect "Permalink",
          to: Routes.post_show_path(@socket, :show, @post),
          class: "text-gray-700 text-center border-t-2 p-2 m-2 uppercase"
        %>
        <button class="text-gray-700 text-center border-t-2 p-2 m-2" type="button" phx-click="like" phx-target="<%= @myself %>">
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
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)

    with true <- socket.assigns.user_id == post.user_id,
         {:ok, _} = Posts.delete_post(post) do
      send(self(), {:post_deleted, nil})
      LiveHelpers.noreply(socket)
    else
      _ ->
        LiveHelpers.noreply(socket)
    end
  end

  @impl true
  def handle_event("like", _, socket) do
    Til.Posts.increment_likes(socket.assigns.post)

    LiveHelpers.noreply(socket)
  end
end
