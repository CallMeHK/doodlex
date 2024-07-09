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

    bar_width = "width: calc(#{hp_bar_width}% - 10px);"
    bar_color = cond do 
      100 * current_hp / assigns.max_hp > 40 -> 
        "background: #44cc57;" 
      100 * current_hp / assigns.max_hp > 20 -> 
        "background: #c0ac2e;" 
      true -> 
        "background: #c54;" 
    end 

    hp_text = "#{current_hp} / #{assigns.max_hp}"

    ~H"""
    <div>
      <style>
        <%= "#heath-bar-#{@id} {"  %>
            .health-bar {
              -webkit-box-sizing: border-box;
              -moz-box-sizing: border-box;
              box-sizing: border-box;
              width: 100%;
              height: 75px;
              padding: 5px;
              background: #ddd;
              -webkit-border-radius: 5px;
              -moz-border-radius: 5px;
              border-radius: 5px;
              position: relative;
            }
            .bar {
              <%= bar_color %>
              <%= bar_width %>
              height: 65px;
              position: absolute;
              top: 5px;
              left: 5px;
              bottom: 0;
              z-index: 20;
              
              transition: width .5s linear;
            }
            .hit {
              background: #cca49f;
              <%= bar_width %>
              height: 65px;
              position: absolute;
              top: 5px;
              left: 5px;
              bottom: 0;
              z-index: 10;
              
              transition: width .5s ease-in-out .5s;
            }
            .hp {
              position: absolute;
              top: 5px;
              right: 10px;
              bottom: 0;
              z-index: 30;
              font-weight: bold;
              font-size: 40px;
            }
          }
      </style>
      <div  id={"heath-bar-#{@id}"}>
        <div class="health-bar">
          <div id={"#{@id}-bar"} class="bar"></div>
          <div id={"#{@id}-hit"} class="hit"></div>
          <div id={"#{@id}-hp"} class="hp"><%= hp_text %></div>
        </div>
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
