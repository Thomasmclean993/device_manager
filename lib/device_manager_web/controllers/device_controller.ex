defmodule DeviceManagerWeb.DeviceController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Device
  alias DeviceManager.DeviceDataStorage, as: DDS
  alias DeviceManager.Devices.Reading
  alias DeviceManagerWeb.ChangesetJSON

  action_fallback DeviceManagerWeb.FallbackController

  def show(conn, %{"id" => id}) do
    data = DDS.retrieve_devices_data(id) |> IO.inspect()

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

  def store(conn, %{"id" => id, "readings" => reading} = params) do
    IO.inspect(params)
    validated_changeset = Device.changeset(%Device{}, params)

    if validated_changeset.valid? do
      DDS.add_data(params)
      json(conn, params)
    else
      %{errors: errors} = ChangesetJSON.error(%{changeset: validated_changeset})
      {:error, :invalid_data}
    end
  end

  def store(conn, _params), do: {:error, :invalid_format}
end
