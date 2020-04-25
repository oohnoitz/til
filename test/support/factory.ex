defmodule Til.Factory do
  alias Til.{Repo, APIKey}
  use ExMachina.Ecto, repo: Repo
  alias Til.Generators

  def user_factory do
    Generators.generate(:user)
  end

  def api_key_factory do
    %APIKey{
      user: build(:user),
      prefix: sequence(:prefix, &"til.#{&1}"),
      key_hash: Bcrypt.hash_pwd_salt("test")
    }
  end
end
