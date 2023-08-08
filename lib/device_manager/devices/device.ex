defmodule DeviceManager.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "device" do
    has_many :readings, DeviceManager.Reading

    timestamps()
  end

  @uuid_regex ~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

  @doc false

  def changeset(device, attrs) do
    id = valid_id(attrs)

    device
    |> cast(attrs, [])
    |> convert_id_to_identifier(id)
    |> cast_assoc(:readings, required: true)
    |> validate_required([:id, :readings])
    |> validate_format(:id, @uuid_regex)
  end

  defp valid_id(attrs) do
    if Map.has_key?(attrs, "id") do
      attrs["id"]
    else
      ""
    end
  end

  def fetch_errors(changeset) do
    if changeset.valid? do
      changeset
    else
      traverse_errors(changeset, fn {msg, _opts} -> msg end)
    end
  end

  defp convert_id_to_identifier(changeset, id) do
    case get_change(changeset, :id, id) do
      nil ->
        changeset

      id ->
        change(changeset, id: "#{id}")
    end
  end
end
