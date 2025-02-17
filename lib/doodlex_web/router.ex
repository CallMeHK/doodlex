defmodule DoodlexWeb.Router do
  use DoodlexWeb, :router

  import DoodlexWeb.UserAuth

  pipeline :phx_default do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DoodlexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :base do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :base_layout do
    plug :put_root_layout, html: {DoodlexWeb.Layouts, :base}
  end

  pipeline :base_layout_light do
    plug :put_root_layout, html: {DoodlexWeb.Layouts, :base_light}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DoodlexWeb do
    pipe_through :base

    get "/", HomeController, :home
    get "/resume", ResumeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DoodlexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:doodlex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    # import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :phx_default

      # live_dashboard "/dashboard", metrics: DoodlexWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", DoodlexWeb do
    pipe_through [:base, :base_layout_light, :require_super_user] 

    live_session :mount_current_super_user,
      on_mount: [{DoodlexWeb.UserAuth, :mount_current_user}] do
      live "/party-tracker/session/create", PartyTracker.CreateSessionLive
      live "/party-tracker/session/:session_id/:method", PartyTracker.CreateSessionLive
      live "/party-tracker/session/all", PartyTracker.AllSessionsLive
    end
  end

  scope "/", DoodlexWeb do
    pipe_through [:base, :base_layout_light] 

    live_session :mount_current_user,
      on_mount: [{DoodlexWeb.UserAuth, :mount_current_user}] do
      live "/party-tracker", PartyTrackerLive
      live "/party-tracker/session/:session_id", PartyTracker.SessionLive
      live "/party-tracker/session/:session_id/character/create", PartyTracker.CreateCharacterLive
      live "/party-tracker/session/:session_id/character/:id", PartyTracker.ViewCharacterLive
      live "/party-tracker/session/:session_id/character/:method/:id", PartyTracker.CreateCharacterLive
    end
  end

  scope "/", DoodlexWeb do
    pipe_through [:phx_default, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DoodlexWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      # live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", DoodlexWeb do
    pipe_through [:phx_default, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DoodlexWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DoodlexWeb do
    pipe_through [:phx_default, :require_super_user]

    import Phoenix.LiveDashboard.Router

    live_dashboard "/dashboard", metrics: DoodlexWeb.Telemetry
    live "/thermostat", ThermostatLive
  end

  scope "/", DoodlexWeb do
    pipe_through [:phx_default]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DoodlexWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
