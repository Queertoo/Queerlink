defmodule Queerlink.Supervisor do
@moduledoc false

use Supervisor
require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    Logger.debug("Supervisor started")
    children = [
      worker(Queerlink.Shortener, []),
    ]
    supervise(children, strategy: :one_for_one)
  end
end
