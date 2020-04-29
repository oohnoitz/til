defmodule Til.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Til.Repo

  alias Til.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Post
    |> order_by([p], desc: p.id)
    |> preload([:tag, :user])
    |> Repo.all()
  end

  def list_posts(page) do
    Post
    |> order_by([p], desc: p.id)
    |> preload([:tag, :user])
    |> Repo.paginate(page: page)
  end

  def list_posts_by_tag(tag_id, page) do
    Post
    |> where([p], p.tag_id == ^tag_id)
    |> order_by([p], desc: p.id)
    |> preload([:tag, :user])
    |> Repo.paginate(page: page)
  end

  def list_posts_by_user(user_id, page) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> order_by([p], desc: p.id)
    |> preload([:tag, :user])
    |> Repo.paginate(page: page)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> preload([:tag, :user])
    |> Repo.get!(id)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post_by_slug!("123-slug")
      %Post{}

      iex> get_post_by_slug!("123-slug")
      ** (Ecto.NoResultsError)

  """
  def get_post_by_slug!(slug) do
    Post
    |> preload([:tag, :user])
    |> Repo.get_by!(slug: slug)
  end

  @doc """
  Gets a random single post.

  ## Examples

      iex> get_random_post()
      %Post{}

      iex> get_random_post()
      nil

  """
  def get_random_post do
    Post
    |> preload([:tag, :user])
    |> order_by(fragment("RANDOM()"))
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Post.add_slug()
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def increment_likes(%Post{id: id}) do
    Post
    |> where([p], p.id == ^id)
    |> Repo.update_all(inc: [likes: 1])

    broadcast({:ok, get_post!(id)}, :post_updated)
  end

  def subscribe(topic \\ "posts") do
    Phoenix.PubSub.subscribe(Til.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Til.PubSub, "posts", {event, post})
    Phoenix.PubSub.broadcast(Til.PubSub, "post:#{post.id}", {event, post})

    {:ok, post}
  end
end
