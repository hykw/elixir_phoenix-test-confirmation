defmodule Test.ETSProc do
  use GenServer

  alias Test.{
    Repo,
    Test,
  }


  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_one(code) do
    GenServer.call(__MODULE__, {:get_one, code})
  end

  ##################################################

  def init(%{}) do
    table = :ets.new(:ets, [:named_table])

    table
    |> copy_ecto()

    {:ok, table}
  end


  defp copy_ecto(table) do
    Repo.all(Test)
    |> Enum.each(fn(x) ->
      :ets.insert(table, {x.code, x.str})
    end)
  end


  def handle_call({:get_one, code}, _from, state) do
    [{code, str}] = :ets.lookup(state, code)
    {:reply, str, state}
  end

end
