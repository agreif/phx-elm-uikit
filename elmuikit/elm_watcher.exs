defmodule ElmWatcher do
  @moduledoc """
  Watches changes on elm files and compiles if needed.
  Then tells the mac to say "ok" or "elm error"

  Run it with
  $ mix run elm_watcher.exs
  """

  use GenServer
  import Say

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    filename = Path.basename(path)

    if :closed in events and not (filename =~ ~r/^#/) do
      IO.puts(path)

      {_, result} =
        System.cmd(
          System.cwd() <> "/node_modules/.bin/elm",
          ["make", System.cwd() <> "/assets/elm/src/Main.elm", "--optimize", "--output=" <> System.cwd() <> "/assets/vendor/elm.js"],
          cd: System.cwd() <> "/assets/elm"
        )

      case result do
        0 -> say("ok")
        _ -> say("elm error")
      end

      IO.puts("-----------------------------------------------------------")
    end

    {:noreply, state}
  end

  def loop do
    receive do
      msg ->
        IO.inspect(msg, label: "inside process loop")
        loop()
    end
  end
end

ElmWatcher.start_link(dirs: ["assets/elm/src"])
IO.puts("elm watcher running...")
ElmWatcher.loop()
