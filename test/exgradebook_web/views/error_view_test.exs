defmodule ExgradebookWeb.ErrorViewTest do
  use ExgradebookWeb.ConnCase, async: true

  test "renders 404.html" do
    assert render_to_string(ExgradebookWeb.ErrorView, "404.html", []) ==
           "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ExgradebookWeb.ErrorView, "500.html", []) ==
           "Internal Server Error"
  end
end
