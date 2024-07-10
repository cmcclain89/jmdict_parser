defmodule Jmdict.Entry do
  # import SweetXml
  alias Jmdict.{KanjiElement, ReadingElement, Sense}

  @moduledoc """
  :ent_seq - a unique identifier
  :r_ele - reading elements
  :sense - definitions
  :k_ele - kanji elements. optional. if present, is the defining unit of the entry.
  """
  defstruct [:ent_seq, :r_ele, :sense, k_ele: []]

  def new(%{ent_seq: ent_seq, k_ele: k_ele, r_ele: r_ele, sense: sense})
      when is_integer(ent_seq) and is_list(k_ele) and is_list(r_ele) and is_list(sense) do
    reading_elements = ReadingElement.parse_list(r_ele)
    kanji_elements = KanjiElement.parse_list(k_ele)
    sense_collection = Sense.parse_list(sense)

    %Jmdict.Entry{
      ent_seq: ent_seq,
      r_ele: reading_elements,
      k_ele: kanji_elements,
      sense: sense_collection
    }
  end
end
