defmodule DoodlexWeb.ResumeHTML do
  use DoodlexWeb, :html

  def index(assigns) do
    ~H"""
    <main class="container">
      <.markdown file="resume.md" />
    </main>
    """
  end
end
