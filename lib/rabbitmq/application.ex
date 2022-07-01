defmodule Rabbitmq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Rabbitmq.Worker.start_link(arg)
       {Rabbitmq.WorkerSendMessage, nil},
       {Rabbitmq.WorkerReceiveMessage, nil}

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rabbitmq.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
