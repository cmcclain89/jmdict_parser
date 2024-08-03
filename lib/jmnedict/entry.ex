defmodule YomiKomi.Jmnedict.Entry do
  # import SweetXml
  alias YomiKomi.Jmnedict.{KanjiElement, ReadingElement, Trans}

  @moduledoc """
  :ent_seq - a unique identifier
  :r_ele - reading elements
  :sense - definitions
  :k_ele - kanji elements. optional. if present, is the defining unit of the entry.
  """
  defstruct [:ent_seq, :r_ele, :trans, k_ele: []]

  def new(%{ent_seq: ent_seq, k_ele: k_ele, r_ele: r_ele, trans: trans}) do
    reading_elements = ReadingElement.parse_list(r_ele)
    kanji_elements = KanjiElement.parse_list(k_ele)
    trans = Trans.new(trans)

    %__MODULE__{
      ent_seq: ent_seq,
      r_ele: reading_elements,
      k_ele: kanji_elements,
      trans: trans
    }
  end
end
