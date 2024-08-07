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
    dic_number = ~x".//dic_number"e
    query_code = ~x".//query_code"e
    reading_meaning = ~x".//reading_meaning"e

    kanjidic2_file()
    |> File.stream!(read_ahead: 250_000)
    |> stream_tags!([:character], discard: [:character], dtd: :internal_only)
    |> Flow.from_enumerable()
    |> Flow.map(fn {_, doc} ->
      %{
        literal: xpath(doc, literal),
        codepoint: xpath(doc, codepoint),
        radical: xpath(doc, radical),
        misc: xpath(doc, misc),
        dic_number: xpath(doc, dic_number),
        query_code: xpath(doc, query_code),
        reading_meaning: xpath(doc, reading_meaning)
      }
      |> YomiKomi.Kanjidic2.Character.new()
    end)
    |> Enum.to_list()
    |> Enum.filter(fn x -> is_nil(x.reading_meaning) end)
  end

  def read(:jmnedict) do
    ent_seq = ~x".//ent_seq/text()"i
    k_ele = ~x".//k_ele"l
    r_ele = ~x".//r_ele"l
    trans = ~x".//trans"e

    jmnedict_file()
    |> File.stream!(read_ahead: 250_000)
    |> stream_tags!([:entry], discard: [:entry], dtd: :internal_only)
    |> Flow.from_enumerable()
    |> Flow.map(fn {_, doc} ->
      cool =
        %{
          ent_seq: xpath(doc, ent_seq),
          k_ele: xpath(doc, k_ele),
          r_ele: xpath(doc, r_ele),
          trans: xpath(doc, trans)
        }
        |> YomiKomi.Jmnedict.Entry.new()

      IO.inspect(cool.ent_seq, label: "Processed")

      cool
    end)
    |> Enum.to_list()
  end

  def read(:tatoeba) do
    tatoeba_file()
    |> File.stream!(read_ahead: 250_000)
    |> Flow.from_enumerable()
    |> Flow.filter(fn line -> String.first(line) == "A" end)
    |> Flow.map(fn line ->
      YomiKomi.Tatoeba.Sentence.new(line)
    end)
    |> Enum.to_list()
  end

  def read(:kradfile) do
    kradfile_u_file()
    |> File.stream!(read_ahead: 250_000)
    |> Flow.from_enumerable()
    |> Flow.filter(fn line -> String.first(line) != "#" end)
    |> Flow.map(fn line ->
      YomiKomi.Kradfile.RadicalDecomposition.new(line)
    end)
    |> Enum.to_list()
  end

  def jmdict_file do
    Application.app_dir(:yomikomi, "/priv/JMdict_e.xml")
  end

  def kanjidic2_file do
    Application.app_dir(:yomikomi, "/priv/kanjidic2.xml")
  end

  def jmnedict_file do
    Application.app_dir(:yomikomi, "/priv/JMnedict.xml")
  end

  def tatoeba_file do
    Application.app_dir(:yomikomi, "/priv/examples.utf.tsv")
  end

  def kradfile_u_file do
    Application.app_dir(:yomikomi, "/priv/kradfile-u.txt")
  end
end
