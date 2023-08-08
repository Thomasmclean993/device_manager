defmodule DeviceManagerWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("422.json", _assigns) do
    %{errors: %{detail: "Duplicate device data"}}
  end

  def render("400.json", %{error: :invalid_data}) do
    %{errors: %{detail: "Request has invalid data"}}
  end

  def render("400.json", %{error: :invalid_format}) do
    %{errors: %{detail: "Request is in a invalid format"}}
  end

  def render("400.json", _assigns) do
    %{errors: %{detail: "Request is either invalid or invalid data"}}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
