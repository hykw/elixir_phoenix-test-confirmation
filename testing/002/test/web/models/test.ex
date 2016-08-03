defmodule Test.Test do
  use Test.Web, :model

  alias Test.{
    Repo,
    Test,
  }


  schema "test" do
    field :code, :integer
    field :str, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :str])
    |> validate_required([:code, :str])
  end
end
