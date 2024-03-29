defmodule DeviceManagerWeb.DeviceController do
  use DeviceManagerWeb, :controller

  alias DeviceManager.Device
  alias DeviceManager.DeviceDataStorage, as: DDS

  action_fallback DeviceManagerWeb.FallbackController

  @doc """
    The show/2 function is to retrieve and display data for a specific device using an unique id.
  """
  def show(conn, %{"id" => id}) do
    data = DDS.retrieve_devices_data(id)

    case data do
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render("not_found.json")

      _ ->
        conn
        |> put_status(:ok)
        |> render("show.json", data: data)
    end
  end

  def show(_conn, _parma), do: {:error, :invalid}

  @doc """
    The store/2 function is responsible for storing data for a device.
    Possible errors
  """

  def store(conn, %{"id" => _id, "readings" => _reading} = params) do
    with validated_changeset = Device.changeset(%Device{}, params),
         true <- validated_changeset.valid?,
         :ok <- DDS.add_data(params) do
      json(conn, params)
    else
      false -> {:error, :invalid_data}
      {:error, :duplicate_data, _} -> {:error, :duplicate_data}
      errors -> errors
    end
  end

  def store(_conn, _params), do: {:error, :invalid_format}
end
