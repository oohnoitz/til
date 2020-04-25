defmodule Til.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:body, :string)
    field(:likes, :integer)
    field(:slug, :string)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :slug, :likes])
    |> validate_required([:title, :body, :slug, :likes])
  end
end
