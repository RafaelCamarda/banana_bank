defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "29560000"

      body = ~s({
        "bairro": "",
        "cep": "29560-000",
        "complemento": "",
        "ddd": "28",
        "gia": "",
        "ibge": "3202306",
        "localidade": "Guaçuí",
        "logradouro": "",
        "siafi": "5645",
        "uf": "ES"
      })

      expected_response =
        {:ok,
         %{
           "bairro" => "",
           "cep" => "29560-000",
           "complemento" => "",
           "ddd" => "28",
           "gia" => "",
           "ibge" => "3202306",
           "localidade" => "Guaçuí",
           "logradouro" => "",
           "siafi" => "5645",
           "uf" => "ES"
         }}

      Bypass.expect(bypass, "GET", "/29560000/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
