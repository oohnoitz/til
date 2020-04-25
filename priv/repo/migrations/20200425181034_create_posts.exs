defmodule Til.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string)
      add(:body, :string)
      add(:slug, :text)
      add(:likes, :integer)

      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end
  end
end
