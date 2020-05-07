defmodule Jarvis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Jarvis.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Jarvis.PubSub}
      # Start a worker by calling: Jarvis.Worker.start_link(arg)
      # {Jarvis.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Jarvis.Supervisor)
  end
end
