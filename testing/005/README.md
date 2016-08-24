# UA Inspector の動作確認

## 前準備

- Elixir のプロジェクトを作成
  - `mix new test`

- `vi config/config.exs`
  - `mix ua_inspector.download.databases`
  - `mix ua_inspector.download.short_code_maps`


## テスト

```elixir
$ iex -S mix

> ua_python_request = "python-requests/2.6.0 CPython/2.6.6 Linux/2.6.32-504.16.2.el6.x86_64"
> UAInspector.parse(ua_python_request)
%UAInspector.Result{client: %UAInspector.Result.Client{engine: :unknown,
  name: "Python Requests", type: "library", version: "2.6.0"},
 device: %UAInspector.Result.Device{brand: :unknown, model: :unknown,
  type: "desktop"},
 os: %UAInspector.Result.OS{name: "GNU/Linux", platform: "x64",
  version: :unknown},
 user_agent: "python-requests/2.6.0 CPython/2.6.6 Linux/2.6.32-504.16.2.el6.x86_64"}

> ua_pc_chrome = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
> UAInspector.parse(ua_pc_chrome)
%UAInspector.Result{client: %UAInspector.Result.Client{engine: "Blink",
  name: "Chrome", type: "browser", version: "52.0.2743.116"},
 device: %UAInspector.Result.Device{brand: :unknown, model: :unknown,
  type: "desktop"},
 os: %UAInspector.Result.OS{name: "Windows", platform: :unknown, version: "7"},
 user_agent: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari\n      /537.36"}

> ua_sp_iphone = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_4 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G35 Safari/601.1"
> UAInspector.parse(ua_sp_iphone)
%UAInspector.Result{client: %UAInspector.Result.Client{engine: "WebKit",
  name: "Mobile Safari", type: "browser", version: "9.0"},
 device: %UAInspector.Result.Device{brand: "Apple", model: "iPhone",
  type: "smartphone"},
 os: %UAInspector.Result.OS{name: "iOS", platform: :unknown, version: "9.3.4"},
 user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_4 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko\n      ) Version/9.0 Mobile/13G35 Safari/601.1"}

> ua_tablet_ipad = "Mozilla/5.0 (iPad; CPU OS 9_3_4 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G35 Safari/601.1"
> UAInspector.parse(ua_tablet_ipad)
%UAInspector.Result{client: %UAInspector.Result.Client{engine: "WebKit",
  name: "Mobile Safari", type: "browser", version: :unknown},
 device: %UAInspector.Result.Device{brand: "Apple", model: "iPad",
  type: "tablet"},
 os: %UAInspector.Result.OS{name: "iOS", platform: :unknown, version: "9.3.4"},
 user_agent: "Mozilla/5.0 (iPad; CPU OS 9_3_4 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Versio\n      n/9.0 Mobile/13G35 Safari/601.1"}


> Enum.map([ua_python_request, ua_pc_chrome, ua_sp_iphone, ua_tablet_ipad], fn(ua) ->
  UAInspector.parse(ua) |> Map.get(:device) |> Map.get(:type)
end)
["desktop", "desktop", "smartphone", "tablet"]
```
