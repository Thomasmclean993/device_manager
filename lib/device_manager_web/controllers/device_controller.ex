defmodule DeviceManagerWeb.DeviceController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Device
  alias DeviceManager.DeviceDataStorage, as: DDS
  alias DeviceManager.Devices.Reading
  alias DeviceManagerWeb.ChangesetJSON

  action_fallback DeviceManagerWeb.FallbackController

  def index(conn, _params) do
    readings = Devices.list_readings()
    render(conn, :index, readings: readings)
  end

  def store(conn, params) do
    validated_changeset = Device.changeset(%Device{}, params)

    if validated_changeset.valid? do
      DDS.add_data(params)
      json(conn, params)
    else
      %{errors: errors} = ChangesetJSON.error(%{changeset: validated_changeset})
      {:error, :invalid_data}
    end
  end
end
