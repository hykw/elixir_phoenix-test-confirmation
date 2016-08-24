# Supervisor の worker が逐次実行されることの確認

## 前準備

- Elixir のプロジェクトを作成
  - `mix new test --sup`

```elixir
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Test.Worker1, ["worker1"]),
      worker(Test.Worker2, ["worker2"]),
      worker(Test.Worker3, ["worker3"]),
    ]

    IO.puts "- start of start/2"

    opts = [strategy: :one_for_one, name: Test.Supervisor]
    ret_start_link = Supervisor.start_link(children, opts)

    IO.puts "- end of start/2"
    ret_start_link
  end
```


- テスト

```bash
$ mix test
- start of start/2

-- start: worker1
-- end: worker1

-- start: worker2
-- end: worker2

-- start: worker3
-- end: worker3
- end of start/2
.

Finished in 0.05 seconds
1 test, 0 failures
```

Worker の init で sleep するとそこで処理がブロッキングする。
また、:timer.sleep/1 を削除しても実行の順序が変わることは無い。
