defmodule Later.CLI do
  alias Later.{Print, Commands}

  def main(args) do
    args
    |> Commands.parse_options()
    |> handle()
  end

  defp handle(:help), do: Print.help()
  defp handle({:error, args}), do: Print.error(args)
  defp handle({:show, args}), do: Later.show(args)
  defp handle({:add, args}), do: Later.add(args)
  defp handle({:edit, args}), do: Later.edit(args)
  defp handle({:delete, args}), do: Later.delete(args)
end
