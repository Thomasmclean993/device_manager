defmodule DeviceManagerWeb.DeviceController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Device
  alias DeviceManager.DeviceDataStorage, as: DDS

  action_fallback DeviceManagerWeb.FallbackController

  def show(conn, %{"id" => id}) do
    data = DDS.retrieve_devices_data(id)

    case data do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("not_found.json")

      _ ->
        conn
        |> put_status(:ok)
        |> render("show.json", data: data)
    end
  end

  def store(conn, %{"id" => _id, "readings" => _reading} = params) do
    with validated_changeset = Device.changeset(%Device{}, params),
         true <- validated_changeset.valid?,
         :ok <- DDS.add_data(params) do
      json(conn, params)
    else
      errors -> errors
    end
  end

  def store(_conn, _params), do: {:error, :invalid_format}
end
