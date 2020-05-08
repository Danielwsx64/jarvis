defmodule JarvisWeb.Router do
  use JarvisWeb, :router

  import Phoenix.LiveDashboard.Router

  alias JarvisWeb.Plugs.Authenticated

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {JarvisWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :authenticated do
    plug(Authenticated)
  end

  scope "/auth", JarvisWeb do
    pipe_through(:browser)

    get("/new", AuthController, :new)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  scope "/", JarvisWeb do
    pipe_through([:browser, :authenticated])

    get("/", HomeController, :index)

    live("/live", PageLive, :index)
    live_dashboard("/dashboard", metrics: JarvisWeb.Telemetry)
  end
end
