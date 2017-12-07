defmodule Queerlink do
  @moduledoc false


  defdelegate insert(url),  to: Queerlink.Shortener
  defdelegate lookup(hash), to: Queerlink.Shortener
end
