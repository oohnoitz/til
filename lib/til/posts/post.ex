defmodule Til.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:body, :string)
    field(:likes, :integer, default: 0)
    field(:slug, :string)
    field(:title, :string)

    belongs_to(:user, Til.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
