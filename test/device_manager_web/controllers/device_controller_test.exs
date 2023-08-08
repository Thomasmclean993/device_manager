defmodule DeviceManagerWeb.DeviceControllerTest do
  use DeviceManagerWeb.ConnCase
  use ExUnit.Case, async: true

  import Plug.Conn
  import DeviceManager.DevicesFixtures

  alias DeviceManager.Devices.Reading
  alias DeviceManager.DevicesFixtures
  alias DeviceManager.DeviceDataStorage, as: DDS
  alias DeviceManagerWeb.DeviceController
  alias DeviceManagerWeb.Router

  @consumer_request DevicesFixtures.device_fixture("valid_request.json")
  @invalid_request %{count: "I'm the count", timestamp: nil} |> Jason.encode!()
  @not_found_id "e62b6a99-08a9-4c5b-82c8-a2d5956a57b4"

  describe "show/2" do
    setup do
      DDS.add_data(%{
        "id" => "6e74a46c-dc4f-4f38-9741-b12b526ea0c9",
        "readings" => [
          %{"count" => 5, "timestamp" => "2015-01-06T10:10:10"},
          %{"count" => 5, "timestamp" => "2015-01-06T10:10:10"}
        ]
      })

      DDS.retrieve_devices_data("6e74a46c-dc4f-4f38-9741-b12b526ea0c9")
    end

    test "returns not found when data is not found" do
      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/show", %{"id" => @not_found_id})

      assert response.status == 404
      assert response.resp_body == "Not Found"
    end

    test "returns a successful response when data is found" do
      DDS.add_data(%{
        "id" => "6e74a46c-dc4f-4f38-9741-b12b526ea0c9",
        "readings" => [
          %{"count" => 5, "timestamp" => "2015-01-06T10:10:10"},
          %{"count" => 5, "timestamp" => "2015-01-06T10:10:10"}
        ]
      })

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> get("/api/show", %{"id" => "6e74a46c-dc4f-4f38-9741-b12b526ea0c9"})

      # assert :ok == DDS.retrieve_devices_data("6e74a46c-dc4f-4f38-9741-b12b526ea0c9")
      assert response.status == 200

      assert response.resp_body ==
               "{\"readings\":[{\"count\":5,\"timestamp\":\"2015-01-06T10:10:10\"},{\"count\":5,\"timestamp\":\"2015-01-06T10:10:10\"}]}"
    end
  end

  describe "store/2" do
    test "stores valid request data" do
      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/store", @consumer_request)

      assert response.status == 200

      assert response.body_params == %{
               "id" => "36d5658a-6908-479e-887e-a949ec199272",
               "readings" => [
                 %{"count" => 2, "timestamp" => "2021-09-29T16:08:15+01:00"},
                 %{"count" => 15, "timestamp" => "2021-09-29T16:09:15+01:00"}
               ]
             }
    end

    test "store/2 when request has invalid data" do
      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/store", @invalid_request)

      assert response.status == 400
      assert response.resp_body =~ "{\"errors\":{\"detail\":\"Bad Request\"}}"
    end
  end
end
