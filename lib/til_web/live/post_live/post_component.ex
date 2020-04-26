defmodule TilWeb.PostLive.PostComponent do
  use TilWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <article id="post-<%= @post.id %>" class="rev-Card">
      <div class="rev-Card-header">
        <div class="rev-Row">
          <div class="rev-Col">
            <h2><%= live_redirect @post.title, to: Routes.post_show_path(@socket, :show, @post) %></h2>
            <div class="MediaObject">
              <div class="MediaObject-section">
                <div class="Image-placeholder">
                  <h3><%= String.first(@post.user.name) %></h3>
                </div>
              </div>

              <div class="MediaObject-section">
                <%= @post.user.name %>
                <time><%= @post.inserted_at %></time>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="rev-Card-body" phx-hook="CodeHighlight">
        <div class="rev-Row">
          <div class="rev-Col">
            <%= raw Til.Markdown.to_html(@post.body) %>
          </div>
        </div>

        <div class="rev-Row">
          <div class="rev-Col rev-Col--small4">
            <%= @post.tag.name %>
          </div>
          <div class="rev-Col rev-Col--small4">
            <%= live_redirect "Permalink", to: Routes.post_show_path(@socket, :show, @post) %>
          </div>
          <div class="rev-Col rev-Col--small4">
            <button type="button" phx-click="like" phx-target="<%= @myself %>">
              <i class="gg-heart"></i> <%= @post.likes %>
            </button>
          </div>
        </div>
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
