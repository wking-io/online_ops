defmodule OnlineOps.Email do
  @moduledoc """
  Transactional emails.
  """

  use Bamboo.Phoenix, view: OnlineOpsWeb.EmailView

  alias OnlineOps.Schemas.User
  alias OnlineOpsWeb.LayoutView

  @doc """
  Generates a magic link email.
  """
  def magic_link(magic_token, %User{} = user) do
    base_email()
    |> to(user.email)
    |> subject("Login to your OnlineOps account with this link 🔗")
    |> assign(:magic_token, magic_token)
    |> render(:magic_link)
  end

  defp base_email do
    new_email()
    |> from("Will King <contact@wking.io>")
    |> put_html_layout({LayoutView, "plain_text_email.html"})
  end

end