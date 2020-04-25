defmodule Til.Mailer do
  @moduledoc """
  Til mailer
  """
  use Bamboo.Mailer, otp_app: :til
  use Pow.Phoenix.Mailer

  import Bamboo.Email

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: Application.get_env(:til, :email),
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  def process(email) do
    deliver_now(email)
  end
end
