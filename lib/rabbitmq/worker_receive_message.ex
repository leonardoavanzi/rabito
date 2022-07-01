defmodule Rabbitmq.WorkerReceiveMessage do
  use GenServer

  def init(_) do
    {:ok, nil}
  end

  def start_link(_) do
    IO.puts("Worker receive message stated!!")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start() do
    {:ok, pid} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(pid)

    AMQP.Exchange.declare(channel, "MARMECQMARIAMEC", :direct)
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

    AMQP.Queue.bind(channel, queue_name, "MARMECQMARIAMEC", routing_key: "xyz")

    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

    IO.puts("Press CTRL + C to close")
    wait_for_message(channel)
  end

  def wait_for_message(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts("#{payload}")

        wait_for_message(channel)
    end
  end
end
