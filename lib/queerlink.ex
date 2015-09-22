defmodule Queerlink do
@moduledoc false
use Application
require Logger

  def start(_type, _args) do
    Logger.debug("Starting the Application")
    Queerlink.Supervisor.start_link
  end

  defmodule St do
    defstruct next: 0
  end
end

