defmodule Til.Repo do
  use Ecto.Repo, otp_app: :til, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, opts}
  end
end
