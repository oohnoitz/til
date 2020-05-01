defmodule TilWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use TilWeb, :controller
      use TilWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: TilWeb
      import Plug.Conn
      import Phoenix.LiveView.Controller

      import TilWeb.Gettext

      alias TilWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/til_web/templates",
        namespace: TilWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Harmonium
      import Phoenix.LiveView.Helpers

      import TilWeb.Gettext

      alias TilWeb.Router.Helpers, as: Routes
      alias TilWeb.ErrorHelpers
      alias TilWeb.LiveHelpers
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {TilWeb.LayoutView, "live.html"}

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      import Phoenix.View

      import Harmonium
      import Phoenix.LiveView.Helpers

      import TilWeb.Gettext

      alias TilWeb.Router.Helpers, as: Routes
      alias TilWeb.ErrorHelpers
      alias TilWeb.LiveHelpers
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      import Phoenix.View

      import Harmonium
      import Phoenix.LiveView.Helpers

      import TilWeb.Gettext

      alias TilWeb.Router.Helpers, as: Routes
      alias TilWeb.ErrorHelpers
      alias TilWeb.LiveHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import TilWeb.Gettext
    end
  end

  def mailer_view do
    quote do
      use Phoenix.View,
        root: "lib/til_web/templates",
        namespace: MyAppWeb

      use Phoenix.HTML
      import TilWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
