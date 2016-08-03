defmodule Test.AgentProc do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_one() do
    GenServer.call(__MODULE__, :get_one)
  end


  ##################################################

  def init(%{}) do
    {:ok, agent} = Agent.start_link(fn -> "1" end, name: :agent)
  end


  def handle_call(:get_one, _from, state) do
    data = Agent.get(state, &(&1))
    {:reply, data, state}
  end

end
