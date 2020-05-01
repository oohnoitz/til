defmodule TilWeb.PostLive.FormComponent do
  use TilWeb, :live_component

  alias Til.Posts
  alias Til.Tags

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Posts.change_post(post)

    socket
    |> assign(assigns)
    |> assign(:changeset, changeset)
    |> assign(:tags, Tags.name_and_ids())
    |> assign(:preview?, false)
    |> ok()
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Posts.change_post(post_params)
      |> Map.put(:action, :validate)

    socket
    |> assign(:changeset, changeset)
    |> noreply()
  end

  def handle_event("mode", %{"mode" => mode}, socket) when mode in ["write", "preview"] do
    socket
    |> assign(:preview?, mode === "preview")
    |> noreply()
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Posts.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        socket
        |> put_flash(:info, "Post updated successfully")
        |> push_redirect(to: Routes.post_show_path(socket, :show, post))
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:changeset, changeset)
        |> noreply()
    end
  end

  defp save_post(socket, :new, post_params) do
    post_params = Map.merge(post_params, %{"user_id" => socket.assigns.user_id})

    case Posts.create_post(post_params) do
      {:ok, post} ->
        socket
        |> put_flash(:info, "Post created successfully")
        |> push_redirect(to: Routes.post_show_path(socket, :show, post))
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:changeset, changeset)
        |> noreply()
    end
  end
end
