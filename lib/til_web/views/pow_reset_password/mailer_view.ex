defmodule TilWeb.PowResetPassword.MailerView do
  use TilWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
