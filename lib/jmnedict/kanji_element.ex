defmodule YomiKomi.Jmnedict.KanjiElement do
  import SweetXml

  @moduledoc """
  Represents the Kanji element.

  - :keb - This element will contain a word or short phrase in Japanese
        which is written using at least one non-kana character (usually kanji,
        but can be other characters)
  - :ke_inf - This is a coded information field related specifically to the
        orthography of the keb,
  - :ke_pri - This and the equivalent re_pri field are provided to record
        information about the relative priority of the entry,  and consist
        of codes indicating the word appears in various references which
        can be taken as an indication of the frequency with which the word
        is used.

        The current values in this field are:
        - - news1/2: appears in the "wordfreq" file compiled by Alexandre Girardi
        from the Mainichi Shimbun.
        - ichi1/2: appears in the "Ichimango goi bunruishuu", Senmon Kyouiku
        Publishing, Tokyo, 1998.
        - spec1 and spec2: a small number of words use this marker when they
        are detected as being common, but are not included in other lists.
        - gai1/2: common loanwords, based on the wordfreq file.
        - nfxx: this is an indicator of frequency-of-use ranking in the
        wordfreq file. "xx" is the number of the set of 500 words in which
        the entry can be found, with "01" assigned to the first 500, "02"
        to the second, and so on.
  """
  defstruct [:keb]

  def new(element) when Kernel.elem(element, 1) == :k_ele do
    %__MODULE__{
      keb: xpath(element, ~x"//keb/text()"s)
    }
  end

  def parse_list([element | _] = elements) when Kernel.elem(element, 1) == :k_ele do
    elements
    |> Enum.map(&__MODULE__.new(&1))
  end

  def parse_list([]) do
    []
  end
end
