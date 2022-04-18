defmodule Exmon do
  alias Exmon.Trainer

  defdelegate create_trainer(params), to: Trainer.Create, as: :call
end
