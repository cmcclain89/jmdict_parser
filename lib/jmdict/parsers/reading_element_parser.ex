defmodule Jmdict.Parsers.ReadingElementParser do
  alias Jmdict.ReadingElement



  def format_nokanji(nil), do: false
  def format_nokanji(_), do: true

  def format_re_inf(""), do: nil
  def format_re_inf(val), do: val
end
