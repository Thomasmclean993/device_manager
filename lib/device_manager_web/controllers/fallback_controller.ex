defmodule DeviceManagerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use DeviceManagerWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: DeviceManagerWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: DeviceManagerWeb.ErrorHTML, json: DeviceManagerWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid_data}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: DeviceManagerWeb.ErrorJSON)
    |> render(:"400", %{error: :invalid_data})
  end

  def call(conn, {:error, :invalid_format}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: DeviceManagerWeb.ErrorJSON)
    |> render(:"400", %{error: :invalid_format})
  end

  def call(conn, {:error, :duplicate_data}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: DeviceManagerWeb.ErrorJSON)
    |> render(:"422")
  end

  def call(conn, _error_tuple) do
    conn
    |> put_status(:not_implemented)
    |> put_view(json: DeviceManagerWeb.ErrorJSON)
    |> render(:"501")
  end
end
