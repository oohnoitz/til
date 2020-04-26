defmodule Til.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:body, :string, default: "")
    field(:slug, :string)
    field(:likes, :integer, default: 0)

    belongs_to(:tag, Til.Tags.Tag)
    belongs_to(:user, Til.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :tag_id, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> add_slug()
    |> foreign_key_constraint(:user_id)
  end

  defp add_slug(changeset) do
    case get_field(changeset, :slug) do
      nil ->
        put_change(
          changeset,
          :slug,
          "#{Nanoid.generate()}-#{generate_slug_for_title(get_field(changeset, :title))}"
        )

      _ ->
        changeset
    end
  end

  def generate_slug_for_title(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^A-Za-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  defimpl Phoenix.Param, for: Til.Posts.Post do
    def to_param(%{slug: slug}), do: slug
  end
end
