defmodule Test do

  def run do
    pid_agent = spawn(AgentProc, :init, [])
    pid_ets = spawn(EtsProc, :init, [])

    %{agent: pid_agent, ets: pid_ets}
  end


  def get(:send, %{agent: pid_agent, ets: pid_ets}) do
    send pid_agent, {:get, self}
    receive do
      {:ok, state} -> IO.puts state
    end

    send(pid_ets, {:get, self})
    receive do
      {:ok, state} -> IO.puts state
    end
  end


  def get(:direct, %{agent: _pid_agent, ets: _pid_ets}) do
    IO.puts Agent.get(:agent, &(&1))

    [{:key, value}] = :ets.lookup(:ets, :key)
    IO.puts value
  end


  def get(:pids, %{agent: pid_agent, ets: pid_ets}) do
    send(pid_agent, {:agent_id, self})
    agent_id = receive do
      {:ok, agent_id} -> agent_id
    end

    send(pid_ets, {:table, self})
    table = receive do
      {:ok, table} -> table
    end

    %{agent_id: agent_id, ets_id: table}
  end


  def stop(%{agent: pid_agent, ets: pid_ets}) do
    send(pid_agent, {:stop})
    send(pid_ets, {:stop})
  end


  def alive?(%{agent: pid_agent, ets: pid_ets}) do
    IO.puts "AgentProc: #{Process.alive?(pid_agent)}"
    IO.puts "EtsProc: #{Process.alive?(pid_ets)}"
  end


end

##################################################
defmodule AgentProc do
  def init do
    {:ok, agent} = Agent.start_link(fn -> "agentの値" end, name: :agent)
    loop(agent)
  end

  def loop(agent_id) do
    receive do
      {:get, sender} ->
        state = Agent.get(:agent, &(&1))
        send(sender, {:ok, state})
        loop(agent_id)

      {:agent_id, sender} ->
        send(sender, {:ok, agent_id})
        loop(agent_id)

      {:stop} -> IO.puts "AgentProc: stop"
    end
  end
end


##################################################
defmodule EtsProc do
  def init do
    table = :ets.new(:ets, [:named_table])
    :ets.insert(table, {:key, "etsの値"})
    loop(table)
  end

  def loop(table) do
    receive do
      {:get, sender} ->
        [{:key, value}] = :ets.lookup(:ets, :key)
        send(sender, {:ok, value})
        loop(table)

      {:table, sender} ->
        send(sender, {:ok, table})
        loop(table)

      {:stop} -> IO.puts "EtsProc: stop"
    end
  end
end
