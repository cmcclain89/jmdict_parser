defmodule YomiKomi do
  import SweetXml

  @moduledoc """
  Documentation for `YomiKomi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> YomiKomi.hello()
      :world

  """
  def hello do
    :world
  end

  def read(:jmdict) do
    ent_seq = ~x".//ent_seq/text()"i
    k_ele = ~x".//k_ele"l
    r_ele = ~x".//r_ele"l
    sense = ~x".//sense"l

    jmdict_file()
    |> File.stream!(read_ahead: 250_000)
    |> stream_tags!([:entry], discard: [:entry], dtd: :internal_only)
    |> Flow.from_enumerable()
    |> Flow.map(fn {_, doc} ->
      cool =
        %{
          ent_seq: xpath(doc, ent_seq),
          k_ele: xpath(doc, k_ele),
          r_ele: xpath(doc, r_ele),
          sense: xpath(doc, sense)
        }
        |> YomiKomi.Jmdict.Entry.new()

      IO.inspect(cool.ent_seq, label: "Processed")

      cool
    end)
    |> Enum.to_list()
  end

  def read(:kanjidic2) do
    literal = ~x".//literal/text()"s
    codepoint = ~x".//codepoint"e
    radical = ~x".//radical"e
    misc = ~x".//misc"e

    kanjidic2_file()
    |> File.stream!(read_ahead: 250_000)
    |> stream_tags!([:character], discard: [:character], dtd: :internal_only)
    |> Flow.from_enumerable()
    |> Flow.map(fn {_, doc} ->
      %{
        literal: xpath(doc, literal),
        codepoint: xpath(doc, codepoint),
        radical: xpath(doc, radical),
        misc: xpath(doc, misc)
      }
      |> YomiKomi.Kanjidic2.Character.new()
    end)
    |> Enum.to_list()
  end

  def jmdict_file do
    Application.app_dir(:jmdict_parser, "/priv/JMdict_e.xml")
  end

  def kanjidic2_file do
    Application.app_dir(:jmdict_parser, "/priv/kanjidic2.xml")
  end
end
