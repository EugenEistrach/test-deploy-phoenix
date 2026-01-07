defmodule TestDeployWeb.PageController do
  use TestDeployWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
