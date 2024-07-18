defmodule Jmdict.Parsers.KanjiElementParser do
  alias Jmdict.KanjiElement



  def parse_list([]) do
    []
  end

  def format_ke_inf(""), do: nil
  def format_ke_inf(val), do: val
end
