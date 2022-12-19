defmodule ElmuikitWeb.PageController do
  use ElmuikitWeb, :controller

  def index(conn, %{"page" => page}) do
    render(conn, "index.html", page: page)
  end

  def index(conn, _params) do
    render(conn, "index.html", page: nil)
  end
end
