defmodule BananaBank.Accounts do
  alias BananaBank.Accounts.Create
  alias BananaBank.Accounts.Transaction

  defdelegate create(params), to: Create, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
