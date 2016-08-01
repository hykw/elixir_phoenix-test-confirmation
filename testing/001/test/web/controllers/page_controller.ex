defmodule Test.PageController do
  use Test.Web, :controller

  alias Test.{
    Repo,
    Test,
    ETSProc,
    AgentProc,
  }


  def index(conn, _params) do
    f = fn ->
      # 1ms
      Process.sleep(1)
    end

    render_time(conn, f)
  end


  def ecto1(conn, _) do
    query = Test
            |> where([c], c.code == 0)

    f = fn ->
      # 1レコード取得して捨てるだけ
      _ = Repo.one(query)
    end

    render_time(conn, f)
  end


  def ecto1000(conn, _) do
    query = Test
            |> where([c], c.code >= 1)
            |> where([c], c.code <= 1000)

    # 全レコードをなめて捨てれば、最適化されずに全レコード取得するはず
    f = fn ->
      Repo.all(query)
      |> Enum.each(&(_ = &1))
    end

    render_time(conn, f)
  end


  def ets1(conn, _) do
    f = fn -> ETSProc.get_one(0) end
    render_time(conn, f)
  end


  def ets1000(conn, _) do
    f = fn ->
      Enum.each(1..999, &(ETSProc.get_one(&1)))
    end

    render_time(conn, f)
  end


  def agent1(conn, _) do
    f = fn -> AgentProc.get_one() end
    render_time(conn, f)
  end


  ##################################################

  defp render_time(conn, anonymous) do
    {time, _} = :timer.tc(anonymous)

    params = %{
      string: time,
    }

    render(conn, "index.html", params)
  end


end

