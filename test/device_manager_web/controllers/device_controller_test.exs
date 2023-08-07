defmodule DeviceManagerWeb.DeviceControllerTest do
  use DeviceManagerWeb.ConnCase
  use ExUnit.Case, async: true

  import Plug.Conn
  import DeviceManager.DevicesFixtures

  alias DeviceManager.Devices.Reading
  alias DeviceManager.DevicesFixtures
  alias DeviceManagerWeb.DeviceController
  alias DeviceManagerWeb.Router

  @consumer_request DevicesFixtures.device_fixture("valid_request.json")

  @invalid_request %{count: "I'm the count", timestamp: nil} |> Jason.encode!()

  test "stores valid request data" do
    response =
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/store", @consumer_request)

    assert response.status == 200

    assert response.body_params == %{
             "_json" => [
               %{
                 "id" => "36d5658a-6908-479e-887e-a949ec199272",
                 "readings" => [
                   %{"count" => 2, "timestamp" => "2021-09-29T16:08:15+01:00"},
                   %{"count" => 15, "timestamp" => "2021-09-29T16:09:15+01:00"}
                 ]
               },
               %{
                 "id" => "36d5658a-6908-479e-887e-a949ec199283",
                 "readings" => [
                   %{"count" => 13, "timestamp" => "2021-09-29T16:08:15+01:00"},
                   %{"count" => 28, "timestamp" => "2021-09-29T16:09:15+01:00"}
                 ]
               }
             ]
           }
  end

  test "store/2 when request is in a invalid format" do
    response =
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/store", @invalid_request)

    assert response.status == 400
    # Or some other expected error message
    assert response.resp_body =~ "{\"errors\":{\"detail\":\"Bad Request\"}}"
  end
end
