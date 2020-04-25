defmodule TilWeb.PowEmailConfirmation.MailerView do
  use TilWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
