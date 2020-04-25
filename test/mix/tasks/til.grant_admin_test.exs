defmodule Mix.Tasks.Til.GrantAdmin.Test do
  use Til.DataCase, async: true
  alias Mix.Tasks.Til.GrantAdmin
  alias Til.Users
  import ExUnit.CaptureIO

  test "til.make_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             GrantAdmin.run([user.email])
           end) =~ "is now an admin"

    assert Users.get_user(user.id).role == "admin"
  end
end
