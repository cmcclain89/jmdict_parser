defmodule Jmdict.Parsers.SenseParser do
  import SweetXml

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
