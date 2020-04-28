defmodule TilWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `TilWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, TilWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, TilWeb.ModalComponent, modal_opts)
  end

  def tab_class(true),
    do:
      "bg-white inline-block border-l border-t border-r rounded-t py-2 px-4 text-gray-700 font-semibold"

  def tab_class(_),
    do: "bg-white inline-block py-2 px-4 text-gray-500 hover:text-gray-800 font-semibold"

  def pagination_class(page, total) when page < 1 or page > total,
    do: "block py-2 px-4 text-gray-400 cursor-not-allowed"

  def pagination_class(_, _),
    do:
      "text-center block border border-white rounded hover:border-gray-200 text-blue-500 hover:bg-gray-200 py-2 px-4"
end
