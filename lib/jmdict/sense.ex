defmodule YomiKomi.Jmdict.Sense do
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
  that are equivalents to the Japanese word.
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
      stagk: xpath(element, ~x".//stagk/text()"ls),
      stagr: xpath(element, ~x".//stagr/text()"ls),
      xref: xpath(element, ~x".//xref/text()"ls) |> Enum.map(&parse_ref/1),
      ant: xpath(element, ~x".//ant/text()"s) |> parse_ref(),
      # how do I handle grabbing pos/field from previous entries? not sure yet!
      pos: pos,
      field: field,
      misc: xpath(element, ~x".//misc/text()"ls),
      lsource: xpath(element, ~x".//lsource"el) |> Enum.map(&parse_lsource/1),
      dial: xpath(element, ~x".//dial/text()"ls),
      gloss: xpath(element, ~x".//gloss"el) |> Enum.map(&parse_gloss/1),
      s_inf: xpath(element, ~x".//stagk/text()"s) |> parse_ref()
    }
  end

  def parse_list([element | _] = elements) when Kernel.elem(element, 1) == :sense do
    elements
    |> Enum.reduce({[], {[], []}}, fn item, {processed, last_pos_field} ->
      current_pos = xpath(item, ~x".//pos/text()"ls)
      current_field = xpath(item, ~x".//field/text()"ls)

      next_pos_field =
        maybe_get_next_pos_field(last_pos_field, {current_pos, current_field})

      {[__MODULE__.new(item, next_pos_field) | processed], next_pos_field}
    end)
    |> then(fn {processed, _} -> processed end)
    |> Enum.reverse()
  end

  def maybe_get_next_pos_field({[], []}, current), do: current
  def maybe_get_next_pos_field(previous, {[], []}), do: previous

  def maybe_get_next_pos_field(previous, current) do
    {prev_pos, prev_field} = previous
    {current_pos, current_field} = current

    next_pos = if length(current_pos) == 0, do: prev_pos, else: current_pos
    next_field = if length(current_field) == 0, do: prev_field, else: current_field

    {next_pos, next_field}
  end

  def parse_ref(""), do: nil

  def parse_ref(antonym) do
    antonym
    |> String.split("・")
    |> format_ref()
  end

  def format_ref([word, reading, sense_ref]), do: {word, reading, maybe_as_integer(sense_ref)}
  def format_ref([word, sense_ref]), do: {word, maybe_as_integer(sense_ref)}
  def format_ref([word]), do: {word, :entry}

  def maybe_as_integer(sense_ref) do
    case Integer.parse(sense_ref) do
      {val, _} -> val
      _ -> sense_ref
    end
  end

  def parse_lsource(element) do
    data = xpath(element, ~x".//text()"s) |> parse_attribute()
    lang = xpath(element, ~x".//attribute::xml:lang"s) |> parse_attribute("eng")
    ls_type = xpath(element, ~x".//attribute::ls_type"s) |> parse_attribute("full")
    ls_wasei = xpath(element, ~x".//attribute::ls_wasei"o) |> parse_ls_wasei()

    %{
      value: data,
      lang: lang,
      ls_type: ls_type,
      ls_wasei: ls_wasei
    }
  end

  def parse_gloss(element) do
    data = xpath(element, ~x".//text()"s) |> parse_attribute()
    lang = xpath(element, ~x".//attribute::xml:lang"s) |> parse_attribute("eng")
    g_type = xpath(element, ~x".//attribute::g_type"s) |> parse_attribute(nil)
    g_gend = nil

    %{
      value: data,
      lang: lang,
      g_type: g_type,
      g_gend: g_gend
    }
  end

  def parse_attribute(value, substitute_if_any \\ nil)
  def parse_attribute("", substitute_if_any), do: substitute_if_any
  def parse_attribute(nil, substitute_if_any), do: substitute_if_any
  def parse_attribute(value, _), do: value

  def parse_ls_wasei(~c"y"), do: true
  def parse_ls_wasei(nil), do: false
  # should never hit this though
  def parse_ls_wasei(_), do: nil
end
