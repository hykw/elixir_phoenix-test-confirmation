defmodule Test do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Test.Worker.start_link(arg1, arg2, arg3)
      # worker(Test.Worker, [arg1, arg2, arg3]),

      worker(Test.Worker1, ["worker1"]),
      worker(Test.Worker2, ["worker2"]),
      worker(Test.Worker3, ["worker3"]),
    ]

    IO.puts "- start of start/2"

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Test.Supervisor]
    ret_start_link = Supervisor.start_link(children, opts)

    IO.puts "- end of start/2"
    ret_start_link
  end
end


defmodule Test.Worker1 do
  use GenServer

  def start_link(worker_arg) do
    GenServer.start_link(__MODULE__, worker_arg, name: __MODULE__)
  end

  def init(worker_arg) do
    IO.puts ""
    IO.puts "-- start: #{worker_arg}"
    :timer.sleep(:timer.seconds(3))
    IO.puts "-- end: #{worker_arg}"
    {:ok, []}
  end
end

defmodule Test.Worker2 do
  use GenServer

  def start_link(worker_arg) do
    GenServer.start_link(__MODULE__, worker_arg, name: __MODULE__)
  end

  def init(worker_arg) do
    IO.puts ""
    IO.puts "-- start: #{worker_arg}"
    :timer.sleep(:timer.seconds(3))
    IO.puts "-- end: #{worker_arg}"
    {:ok, []}
  end
end

defmodule Test.Worker3 do
  use GenServer

  def start_link(worker_arg) do
    GenServer.start_link(__MODULE__, worker_arg, name: __MODULE__)
  end

  def init(worker_arg) do
    IO.puts ""
    IO.puts "-- start: #{worker_arg}"
    :timer.sleep(:timer.seconds(3))
    IO.puts "-- end: #{worker_arg}"
    {:ok, []}
  end
end

