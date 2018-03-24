defmodule ExgradebookWeb.Component.Breadcrumb do
  import Phoenix.HTML.Tag

  @doc """
  Creates a list of breadcrumbs for navigation

  Usage:
      <%= breadcrumbs([
        link("Hello World", to: "/landing"),
        link("My Profile", to: "/profile"),
        link("Edit Profile", to: "/profile/edit"),
      ]) %>
  """
  def breadcrumbs(links) do
    content_tag :nav, "aria-control": "breadcrumb" do
      content_tag :ol, class: "breadcrumb" do
        Enum.map links, fn (link) ->
          content_tag :li, link, class: "breadcrumb-item"
        end
      end
    end
  end
end
