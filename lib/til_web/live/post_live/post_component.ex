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
                  <h3>h</h3>
                </div>
              </div>

              <div class="MediaObject-section">
                <%= @post.user_id %>
                <%= @post.inserted_at %>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="rev-Card-body">
        <td><%= @post.body %></td>
      </div>
    </article>
    """
  end
end
