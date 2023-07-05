defmodule BananaBank.Users.Delete do
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
