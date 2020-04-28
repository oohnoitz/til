defmodule Til.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias Til.Repo

  alias Til.Tags.Tag

  @doc """
  Returns the list of tags.
  """
  def list_tags do
    Tag
    |> order_by([t], asc: t.name)
    |> Repo.all()
  end

  def name_and_ids do
    Tag
    |> order_by([t], asc: t.name)
    |> select([t], {t.name, t.id})
    |> Repo.all()
    |> Enum.map(fn {label, id} -> {"##{label}", id} end)
  end
end
