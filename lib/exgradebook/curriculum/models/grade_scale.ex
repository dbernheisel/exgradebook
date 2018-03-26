defmodule Exgradebook.Curriculum.GradeScale do
  @type t :: %__MODULE__{
    letter: String.t,
    min_range: integer,
    max_range: integer,
    points: float,
  }

  defstruct [
    letter: "F",
    min_range: 0,
    max_range: 65,
    points: 0.0,
  ]

  def all_grades do
    [a_plus(), a(), a_minus(), b_plus(), b(), b_minus(), c_plus(), c(), c_minus(), d_plus(), d(), f()]
  end

  def a_plus do
    %__MODULE__{letter: "A+", max_range: 100, min_range: 97, points: 4.0}
  end
  def a do
    %__MODULE__{letter: "A", max_range: 96, min_range: 93, points: 4.0}
  end
  def a_minus do
    %__MODULE__{letter: "A-", max_range: 92, min_range: 90, points: 3.7}
  end
  def b_plus do
    %__MODULE__{letter: "B+", max_range: 89, min_range: 87, points: 3.3}
  end
  def b do
    %__MODULE__{letter: "B", max_range: 86, min_range: 83, points: 3.0}
  end
  def b_minus do
    %__MODULE__{letter: "B-", max_range: 82, min_range: 80, points: 2.7}
  end
  def c_plus do
    %__MODULE__{letter: "C+", max_range: 79, min_range: 77, points: 2.3}
  end
  def c do
    %__MODULE__{letter: "C", max_range: 76, min_range: 73, points: 2.0}
  end
  def c_minus do
    %__MODULE__{letter: "C-", max_range: 72, min_range: 70, points: 1.7}
  end
  def d_plus do
    %__MODULE__{letter: "D+", max_range: 69, min_range: 67, points: 1.3}
  end
  def d do
    %__MODULE__{letter: "D", max_range: 65, min_range: 66, points: 1.0}
  end
  def f do
    %__MODULE__{letter: "F", max_range: 64, min_range: 0, points: 0.0}
  end

  defimpl String.Chars do
    def to_string(%{letter: letter}) do
      letter
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%{letter: letter}) do
      letter
    end
  end
end
