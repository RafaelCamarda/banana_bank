defmodule BananaBankWeb.Token do
  alias BananaBankWeb.Endpoint
  alias Phoenix.Token

  @sign_salt "banana_bank_api"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token), do: Token.verify(Endpoint, @sign_salt, token)
end
