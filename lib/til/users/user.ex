defmodule Til.User do
  use Ecto.Schema
  use Pow.Ecto.Schema, password_hash_methods: {&Bcrypt.hash_pwd_salt/1, &Bcrypt.verify_pass/2}
  import Pow.Ecto.Schema.Changeset, only: [new_password_changeset: 3]

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  use Adminable

  import Ecto.{Query, Changeset}, warn: false

  @type t :: %__MODULE__{}
  schema "users" do
    pow_user_fields()
    field(:name, :string)
    field(:role, :string, default: "user")
    field(:email_verified, :boolean, default: false)

    has_many(:posts, Til.Posts.Post)

    timestamps()
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> pow_user_id_field_changeset(attrs)
    |> pow_current_password_changeset(attrs)
    |> new_password_changeset(attrs, @pow_config)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:name])
  end

  def update_changeset(schema, attrs \\ %{}) do
    changeset(schema, attrs)
  end

  def edit_changeset(schema, attrs \\ %{}) do
    changeset(schema, attrs)
  end

  def create_changeset(schema, attrs) do
    changeset(schema, attrs)
  end
end
