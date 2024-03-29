defmodule FibrilWeb.Router do
  use FibrilWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FibrilWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FibrilWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/pets", PetLive.Index, :index
    live "/pets/new", PetLive.Index, :new
    live "/pets/:id/edit", PetLive.Index, :edit

    live "/pets/:id", PetLive.Show, :show
    live "/pets/:id/show/edit", PetLive.Show, :edit

    # live "/admin/:resource", FibrilLive
    live "/admin/:resource", FibrilLive.Index, :index
    live "/admin/:resource/new", FibrilLive.Index, :new
    live "/admin/:resource/:id/edit", FibrilLive.Index, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FibrilWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fibril, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FibrilWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
