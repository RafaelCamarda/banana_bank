defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias Users.User

  setup do
    params = %{
      "name" => "João",
      "cep" => "29560000",
      "email" => "joao@frutas.com",
      "password" => "123456"
    }

    body = %{
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
    }

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "29560000" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "29560000", "email" => "joao@frutas.com", "id" => _id, "name" => "João"},
               "message" => "User criado com sucesso!"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        name: nil,
        cep: "12",
        email: "joao@frutas.com",
        password: "123456"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}}

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "29560000" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => "29560000", "email" => "joao@frutas.com", "id" => id, "name" => "João"}
      }

      assert response == expected_response
    end
  end
end
