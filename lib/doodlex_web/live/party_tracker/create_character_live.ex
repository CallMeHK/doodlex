defmodule DoodlexWeb.PartyTracker.CreateCharacterLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section id="intro">
            <div class="md-section">
    <form>
      <fieldset>
        <label>
          First name
          <input
            name="first_name"
            placeholder="First name"
            autocomplete="given-name"
          />
        </label>
        <label>
          Email
          <input
            type="email"
            name="email"
            placeholder="Email"
            autocomplete="email"
          />
        </label>
      </fieldset>
    
      <input
        type="submit"
        value="Subscribe"
      />
    </form>
            </div>
         </section>
      </main>
    """
  end

  def mount(_params, _session, socket) do
    temperature = 70 # Let's assume a fixed temperature for now
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    IO.puts "inc_temperature"
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
