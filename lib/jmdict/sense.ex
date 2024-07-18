defmodule Jmdict.Sense do
  @moduledoc """
  The translational equivalent of the Japanese word. Basically, the meaning.

  - :stagk/:stagr - if present, indicates that the sense is restricted to the lexeme
  represented by the keb and/or reb

  - :xref - used to indicate a cross-reference to another entry with similar or related meaning.
  typically a keb or reb from another entry (sometimes contains a more precise using 0x2126 "centre-dot". will revisit later)

  - :ant - indicates an antonym. must exactly match the keb/reb of another entry

  - :pos - part-of-speech info. part of speeches continue to apply from earlier senses
  until another pos is defined for the sense

  - :field - information about the field of application of the entry/sense. When absent,
  general application is implied.

  - :misc - other relevant information about the entry/senses. usually applies to several senses, like
  :pos

  - :lsource - information about the source language(s) of loan-word/gairaigo. If other than English,
  the language is indicated by the xml:lang attribute. The value will be the source word.
    - xml:lang CDATA "eng"
    - ls_type: indicates whether the element fully or partially describes the source word or phrase. If
    absent, implied to be "full". Otherwise will contain "part"
    - ls_wasei: indicates that the Japanese word has been constructed from words in the source language. "waseieigo"

  - :dial - for words specifically associated with regional dialects in Japnaese. Refer to set codes.

  - :gloss - Within each word will be one or more glosses i.e. target-language words or phrases
  that are equivalents to the Japanese word. I'm not actually sure I need this.
    - xml:lang CDATA "eng"
    - g_gend - defines gender of the gloss. When absent the gender is either not relevant or yet to be provided
    - g_type - specifies its of specific type i.e. "lit" (literal), "fig" (figurative), "expl" (explanation)
    - pri - highlights particular target_language words which are strongly associated with the japanese word

  - :s_inf - lists additional information about a sesnse, i.e. level of currency, regional variations, etc

  - :example - The example elements contain a Japanese sentence using the term
    associated with the entry, and one or more translations of that sentence.
    Within the element, the ex_srce element will indicate the source of the
    sentences (typically the sequence number in the Tatoeba Project), the
    ex_text element will contain the form of the term in the Japanese
    sentence, and the ex_sent elements contain the example sentences.
  """

  import SweetXml

  alias Jmdict.Parsers.SenseParser

  defstruct stagk: [],
            stagr: [],
            pos: [],
            xref: [],
            ant: nil,
            field: [],
            misc: [],
            s_inf: [],
            lsource: [],
            dial: [],
            gloss: [],
            example: []

  def new(element, {pos, field}) when Kernel.elem(element, 1) == :sense do
    %__MODULE__{
      stagk: xpath(element, ~x".//stagk/text()"l) |> Enum.map(&to_string/1),
      stagr: xpath(element, ~x".//stagr/text()"l) |> Enum.map(&to_string/1),
      xref:
        xpath(element, ~x".//xref/text()"l)
        |> Enum.map(fn ref ->
          to_string(ref)
          |> SenseParser.parse_ref()
        end),
      ant: xpath(element, ~x".//ant/text()"s) |> SenseParser.parse_ref(),
      # how do I handle grabbing pos/field from previous entries? not sure yet!
      pos: pos,
      field: field,
      misc: xpath(element, ~x".//misc/text()"l) |> Enum.map(&to_string/1),
      lsource: xpath(element, ~x".//lsource"el) |> Enum.map(&SenseParser.parse_lsource/1),
      dial: xpath(element, ~x".//dial/text()"l) |> Enum.map(&to_string/1),
      gloss: xpath(element, ~x".//gloss"el) |> Enum.map(&SenseParser.parse_gloss/1),
      s_inf: xpath(element, ~x".//stagk/text()"s) |> SenseParser.parse_ref()
    }
  end

  def from_list([element | _] = elements) when Kernel.elem(element, 1) == :sense do
    elements
    |> Enum.reduce({[], {[], []}}, fn item, {processed, last_pos_field} ->
      current_pos = xpath(item, ~x".//pos/text()"l) |> Enum.map(&to_string/1)
      current_field = xpath(item, ~x".//field/text()"l) |> Enum.map(&to_string/1)

      next_pos_field =
        SenseParser.maybe_get_next_pos_field(last_pos_field, {current_pos, current_field})

      {[__MODULE__.new(item, next_pos_field) | processed], next_pos_field}
    end)
    |> then(fn {processed, _} -> processed end)
    |> Enum.reverse()
  end
end
