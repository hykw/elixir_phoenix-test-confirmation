# 生成プロセスが死んだらAgent/etsが死ぬのを確認


## 前準備

- Elixir のプロジェクトを作成
  - `mix new test`

- テスト

```bash
$ iex -S mix

> pids = Test.run

> Test.get(:send, pids)
agentの値
etsの値

> Test.get(:direct, pids)
agentの値
etsの値

> Test.alive?(pids)
AgentProc: true
EtsProc: true

> agent_ets = Test.get(:pids, pids)

> Process.alive?(agent_ets.agent_id)
true

> :ets.info(:ets)
[read_concurrency: false, write_concurrency: false, compressed: false,
 memory: 310, owner: #PID<0.105.0>, heir: :none, name: :ets, size: 1,
  node: :nonode@nohost, named_table: true, type: :set, keypos: 1,
   protection: :protected]

> Test.stop(pids)
AgentProc: stop
EtsProc: stop

> Test.alive?(pids)
AgentProc: false
EtsProc: false

> Process.alive?(agent_ets.agent_id)
true

> :ets.info(:ets)
:undefined

> Test.get(:direct, pids)
agentの値
** (ArgumentError) argument error
    (stdlib) :ets.lookup(:ets, :key)
      (test) lib/test.ex:27: Test.get/2
```


## まとめ
Agentはそれを生成したプロセスが死んでも生き続ける。ets はオーナーと一緒に死ぬ。逆の挙動かと思ってたけど、そうではなかった。named の Agent は多重定義しようとすると :already_started になるのでリークすることは無いので問題ないけど。ets は heir とかを使うと生き続けるというか相続させられそう。
