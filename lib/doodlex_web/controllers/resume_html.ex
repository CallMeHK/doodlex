defmodule DoodlexWeb.ResumeHTML do
  use DoodlexWeb, :html

  def index(assigns) do
    ~H"""
    <main class="container">
      <.markdown file="markdown/resume.md" />
    </main>
    """
  end
end
