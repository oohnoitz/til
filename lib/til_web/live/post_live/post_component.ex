defmodule TilWeb.PostLive.PostComponent do
  use TilWeb, :live_component

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

      <div class="rev-Card-body">
        <div class="rev-Row">
          <div class="rev-Col">
            <%= raw Til.Markdown.to_html(@post.body) %>
          </div>
        </div>
      </div>
    </article>
    """
  end
end
