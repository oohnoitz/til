defmodule TilWeb.ModalComponent do
  use TilWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="rev-Modal rev-Modal--open"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="rev-Modal-content">
        <div class="rev-Row">
          <div class="rev-Col">
            <%= live_patch raw("&times;"), to: @return_to, class: "rev-CloseButton" %>

            <%= live_component @socket, @component, @opts %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
