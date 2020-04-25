defmodule TilWeb.API.MeView do
  use TilWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        email: user.email
      }
    }
  end
end
