defmodule DeviceManagerWeb.ReadingControllerTest do
  use DeviceManagerWeb.ConnCase

  import DeviceManager.DevicesFixtures

  alias DeviceManager.Devices.Reading

  @create_attrs %{
    count: 42,
    timestamp: ~U[2023-08-04 18:41:00Z]
  }
  @update_attrs %{
    count: 43,
    timestamp: ~U[2023-08-05 18:41:00Z]
  }
  @invalid_attrs %{count: nil, timestamp: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag :skip
  describe "index" do
    test "lists all readings", %{conn: conn} do
      conn = get(conn, ~p"/api/readings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  @tag :skip
  describe "create reading" do
    test "renders reading when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/readings", reading: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/readings/#{id}")

      assert %{
               "id" => ^id,
               "count" => 42,
               "timestamp" => "2023-08-04T18:41:00Z"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/readings", reading: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  @tag :skip
  describe "update reading" do
    setup [:create_reading]

    test "renders reading when data is valid", %{conn: conn, reading: %Reading{id: id} = reading} do
      conn = put(conn, ~p"/api/readings/#{reading}", reading: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/readings/#{id}")

      assert %{
               "id" => ^id,
               "count" => 43,
               "timestamp" => "2023-08-05T18:41:00Z"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, reading: reading} do
      conn = put(conn, ~p"/api/readings/#{reading}", reading: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  @tag :skip
  describe "delete reading" do
    setup [:create_reading]

    test "deletes chosen reading", %{conn: conn, reading: reading} do
      conn = delete(conn, ~p"/api/readings/#{reading}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/readings/#{reading}")
      end
    end
  end

  defp create_reading(_) do
    reading = reading_fixture()
    %{reading: reading}
  end
end
