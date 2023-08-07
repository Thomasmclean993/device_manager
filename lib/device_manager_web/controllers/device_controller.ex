defmodule DeviceManagerWeb.DeviceController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Devices
  alias DeviceManager.DeviceDataStorage, as: DDS
  alias DeviceManager.Devices.Reading
  alias DeviceManager.Validator

  action_fallback DeviceManagerWeb.FallbackController

  def index(conn, _params) do
    readings = Devices.list_readings()
    render(conn, :index, readings: readings)
  end

  def store(conn, params) do
    with {:ok, valid_formated_request} <- Validator.validate_format(params),
         {:ok, request_with_validated_data} <- Validator.validate_data(valid_formated_request),
         {:ok, save_request} <- DDS.insert_list_of_devices(request_with_validated_data) do
      json(conn, save_request)
    else
      error ->
        error
    end
  end
end
