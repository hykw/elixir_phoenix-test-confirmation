# Cachex の動作確認

## 前準備

- Elixir のプロジェクトを作成
  - `mix new cachextest --sup`

- テスト

```bash
$ iex -S mix

> Cachex.set(:cachex, "key", "値", [ ttl: :timer.seconds(5) ])

> Cachex.get(:cachex, "unknown")
{:missing, nil}

> Cachex.get(:cachex, "key")
{:ok, "値"}

5秒経過後
> Cachex.get(:cachex, "key")
{:missing, nil}
```

```bash
> Cachex.set(:cachex, "key2", "値", [])

> Cachex.get(:cachex, "key2")
{:ok, "値"}

※5秒経過後も（当然）取得可能
```

```bash
> Cachex.get(:xxx, "key")
{:error, "Invalid cache provided, got: :xxx"}
```

```bash
> Cachex.get(:cachex, "key")
{:missing, nil}

> Cachex.get(:cachex, "key", fallback: fn(key) -> "あいうえお" end)
{:loaded, "あいうえお"}

> Cachex.get(:cachex, "key")
{:missing, nil}

> Cachex.get(:cachex, "key", fallback: fn(key) -> "22222" end)
{:loaded, "あいうえお"}
```
