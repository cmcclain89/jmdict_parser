defmodule YomiKomi.Jmnedict.Trans do
  import SweetXml

  defstruct nametype: [], xref: [], trans_det: []

  def new(element) when Kernel.elem(element, 1) == :trans do
    %__MODULE__{
      nametype: xpath(element, ~x".//nametype/text()"ls),
      xref: xpath(element, ~x".//xref/text()"ls),
      trans_det: xpath(element, ~x".//trans_det/text()"ls)
    }
  end
end
