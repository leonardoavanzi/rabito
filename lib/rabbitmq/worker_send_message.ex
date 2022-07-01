defmodule Rabbitmq.WorkerSendMessage do
  use GenServer

  def init(_) do
    {:ok, nil}
  end

  def start_link(_) do
    IO.puts("worker send message started !")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start() do
    name = IO.gets("Name: ")
    send_message(name)
  end

  def send_message(name) do
    # open pid connection
    {:ok, pid} = AMQP.Connection.open()

    # channel open
    {:ok, channel} = AMQP.Channel.open(pid)

    message = IO.gets("your input here: ")
    text = "#{name}" <> message

    AMQP.Exchange.declare(channel, "MARMECQMARIAMEC", :direct)

    AMQP.Basic.publish(channel, "MARMECQMARIAMEC", "xyz", text)

    send_message(name)
    AMQP.Connection.close(pid)


  end
end
