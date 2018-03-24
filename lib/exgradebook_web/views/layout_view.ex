defmodule ExgradebookWeb.LayoutView do
  use ExgradebookWeb, :view

  def nav_link(text, options) do
    content_tag :li, [class: "nav-item"] do
      link(text, Keyword.put(options, :class, "nav-link"))
    end
  end
end
