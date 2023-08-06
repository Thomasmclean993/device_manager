defmodule DeviceManagerWeb.ReadingController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Devices
  alias DeviceManager.Devices.Reading

  action_fallback DeviceManagerWeb.FallbackController

  def index(conn, _params) do
    readings = Devices.list_readings()
    render(conn, :index, readings: readings)
  end

  def create(conn, %{"reading" => reading_params}) do
    with {:ok, %Reading{} = reading} <- Devices.create_reading(reading_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/readings/#{reading}")
      |> render(:show, reading: reading)
    end
  end

  def show(conn, %{"id" => id}) do
    reading = Devices.get_reading!(id)
    render(conn, :show, reading: reading)
  end

  def update(conn, %{"id" => id, "reading" => reading_params}) do
    reading = Devices.get_reading!(id)

    with {:ok, %Reading{} = reading} <- Devices.update_reading(reading, reading_params) do
      render(conn, :show, reading: reading)
    end
  end

  def delete(conn, %{"id" => id}) do
    reading = Devices.get_reading!(id)

    with {:ok, %Reading{}} <- Devices.delete_reading(reading) do
      send_resp(conn, :no_content, "")
    end
  end
end
