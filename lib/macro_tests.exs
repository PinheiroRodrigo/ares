defmodule Mycros do

  def fun_unless(clause, do: expression) do
    if(!clause, do: expression)
  end

  defmacro macro_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end

  defmacro macro_if(clause, do: do_clause, else: else_clause) do
    quote do
      if unquote(clause), do: unquote(do_clause), else: unquote(else_clause)
    end
  end


end
