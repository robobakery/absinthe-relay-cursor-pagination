defmodule PagiWeb.PageController do
  use PagiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
