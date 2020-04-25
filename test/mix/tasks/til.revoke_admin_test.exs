defmodule Mix.Tasks.Til.RevokeAdmin.Test do
  use Til.DataCase, async: true
  alias Mix.Tasks.Til.RevokeAdmin
  alias Til.Users
  import ExUnit.CaptureIO

  test "til.revoke_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             RevokeAdmin.run([user.email])
           end) =~ "admin access revoked"

    assert Users.get_user(user.id).role == "user"
  end
end
