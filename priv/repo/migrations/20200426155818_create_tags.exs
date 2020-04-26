defmodule Til.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps()
    end

    alter table(:posts) do
      add :tag_id, references(:tags)
    end
  end
end
