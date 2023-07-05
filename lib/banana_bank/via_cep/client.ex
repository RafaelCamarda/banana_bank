defmodule BananaBank.ViaCep.Client do
  use Tesla

  alias BananaBank.ViaCep.ClientBehaviour

  @default_url "https://viacep.com.br/ws"
  plug Tesla.Middleware.JSON

  @behaviour ClientBehaviour

  @impl ClientBehaviour
  def call(url \\ @default_url, cep) do
    "#{url}/#{cep}/json"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: %{"erro" => true}}}) do
    {:error, :not_found}
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {:error, :bad_request}
  end

  defp handle_response({:error, _reason}) do
    {:error, :internal_server_error}
  end
end
