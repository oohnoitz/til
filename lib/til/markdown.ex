defmodule Til.Markdown do
  @moduledoc false

  def to_html(markdown) do
    options = %Earmark.Options{
      code_class_prefix: "language-",
      pure_links: true
    }

    markdown
    |> Earmark.as_html!(options)
    |> String.trim()
  end
end
