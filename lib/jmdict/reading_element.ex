defmodule YomiKomi.Jmdict.ReadingElement do
  import SweetXml

  @moduledoc """
  Represents the reading element. May be the primary element if no keb

  - :reb - the word I guess. kana and related chars only
  - :re_nokanji - will usually be null. indicates that the reb associated with the keb
  cannot be regarded as the true reading of the kanji
  - :re_restr - indicates that reading only applies to a subset of the keb elements
  - :re_inf - coded information pretaining to the specific reading
  - :re_pri - same as ke_pri
  """
  defstruct [:reb, re_restr: [], re_inf: [], re_pri: nil, re_nokanji: false]

  def new(element) when Kernel.elem(element, 1) == :r_ele do
    %__MODULE__{
      reb: xpath(element, ~x"//reb/text()"s),
      re_nokanji: xpath(element, ~x".//re_nokanji"o) |> format_nokanji(),
      re_restr: xpath(element, ~x".//re_restr/text()"ls),
      re_inf: xpath(element, ~x".//re_inf/text()"ls),
      re_pri: xpath(element, ~x".//re_pri/text()"ls)
    }
  end

  def parse_list([element | _] = elements) when Kernel.elem(element, 1) == :r_ele do
    elements
    |> Enum.map(&__MODULE__.new(&1))
  end

  def format_nokanji(nil), do: false
  def format_nokanji(_), do: true

end
