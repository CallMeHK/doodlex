defmodule Doodlex.PartyTracker.Components.Healthbar do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    {current_hp, hp_bar_width} = cond do
      is_integer(assigns.current_hp) -> 
        hp_bar_width = Float.to_string(100 * assigns.current_hp / assigns.max_hp)
        {assigns.current_hp, hp_bar_width}
      %Phoenix.LiveView.AsyncResult{ok?: ok?, result: result} = assigns.current_hp ->
        current_hp = if ok?, do: result, else: assigns.max_hp
        hp_bar_width = if ok?, do: Float.to_string(100 * result / assigns.max_hp), else: "100"
        {current_hp, hp_bar_width}   
    end
    
    ~H"""
    <div>
      <div>
        <style>
          @scope {
            :scope {
              <%= "--hp-bar-width: calc(#{hp_bar_width}% - 10px);" %>
              .health-bar {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                width: 100%;
                height: 50px;
                padding: 5px;
                background: #ddd;
                -webkit-border-radius: 5px;
                -moz-border-radius: 5px;
                border-radius: 5px;
                position: relative;
              }
              .bar {
                <%= cond do %>
                  <%= 100 * current_hp/@max_hp > 40 -> %>
                    <%= "background: #44cc57;" %>
                  <%= 100 * current_hp/@max_hp > 20 -> %>
                    <%= "background: #d1d72c;" %>
                  <%= true -> %>
                    <%= "background: #c54;" %>
                <% end %>
                <%= "width: calc(#{hp_bar_width}% - 10px);" %>
                height: 40px;
                position: absolute;
                top: 5px;
                left: 5px;
                bottom: 0;
                z-index: 20;
                
                transition: width .5s linear;
              }
              .hit {
                background: #cca49f;
                <%= "width: calc(#{hp_bar_width}% - 10px);" %>
                height: 40px;
                position: absolute;
                top: 5px;
                left: 5px;
                bottom: 0;
                z-index: 10;
                
                transition: width .5s ease-in-out .5s;
              }
            }
          }
        </style>
        <div class="health-bar">
          <div id={"#{@id}-bar"} class="bar"></div>
          <div id={"#{@id}-hit"} class="hit"></div>
        </div>
        <script>
        setTimeout(() => {
          document.getElementById("<%= "#{@id}-bar" %>").setAttribute('class', 'bar')
          document.getElementById("<%= "#{@id}-hit" %>").setAttribute('class', 'hit')
        }, 1000)
        </script>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, %{assigns: %{mounted: true}} = socket) do
    {:ok, socket 
      |> assign(assigns)}
  end

  def update(assigns, socket) do
    %{current_hp: current_hp, max_hp: max_hp} = assigns
    IO.puts "--hp-bar-width: calc(#{Float.to_string(100 * current_hp/max_hp)}% - 10px);"
    {:ok, socket 
      |> assign(mounted: true)
      |> assign(assigns)
      |> assign_async(:current_hp, fn -> 
        :timer.sleep(1)
        {:ok, %{current_hp: current_hp}}
        end)
        }
  end
end
