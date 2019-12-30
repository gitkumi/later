defmodule Later.Print do
  alias Later.Commands

  @help_title "Later"
  @help_description "Log it now, do it later. Todo list on your terminal written on Elixir."
  @repo_link "https://github.com/gitkumi/later"
  @tab "  "

  def main(nil) do
    IO.puts(" ")
    IO.puts(" Todo not found.")
    IO.puts(" ")

    :ok
  end

  def main([]) do
    IO.puts(" ")
    IO.puts(" Your list is empty.")
    IO.puts(" ")

    :ok
  end

  def main(todos) when is_list(todos) do
    IO.puts(" ")
    IO.puts(" #{ansi_bright()}Todos#{ansi_normal()}")
    IO.puts(" ")
    Enum.each(todos, fn t -> print_todo(t) end)
    IO.puts(" ")

    :ok
  end

  def main(todo) do
    IO.puts(" ")
    print_todo(todo)
    IO.puts(" ")

    if Map.get(todo, :description) != nil do
      IO.puts("#{@tab}- #{todo.description}")
      IO.puts(" ")
    end

    :ok
  end

  def help() do
    IO.puts(" ")
    IO.puts(" #{ansi_bright()}#{@help_title}#{ansi_normal()}")
    IO.puts(" #{@help_description}")
    IO.puts(" ")
    IO.puts(" #{ansi_bright()}Repository#{ansi_normal()}")
    IO.puts(" #{@repo_link}")
    IO.puts(" ")
    IO.puts(" #{ansi_bright()}Commands#{ansi_normal()}")
    Enum.each(Commands.get_commands(), fn command -> print_help(command) end)
    IO.puts(" ")

    :ok
  end

  def error(args) do
    IO.puts(" ")
    IO.puts(" #{args.reason}")
    IO.puts(" ")

    :ok
  end

  defp print_todo(todo),
    do: IO.puts(" #{todo.id}. #{ansi_bright()}#{todo.title}#{ansi_normal()}")

  defp print_help(command) do
    command_name = "#{ansi_bright()}· #{command.name}#{ansi_normal()}"
    command_alias = "(-#{command.alias})"
    command_description = "#{command.description}"

    command_examples = command.examples
    command_parameters = command.parameters

    IO.puts(" ")
    IO.puts(" #{@tab}#{command_name} #{command_alias}")
    IO.puts(" #{@tab}#{ansi_faint()}#{command_description}#{ansi_normal()}")

    if command_parameters do
      IO.puts(" ")
      IO.puts(" #{@tab}#{@tab}#{ansi_bright()}parameters#{ansi_normal()}")

      Enum.each(command_parameters, fn param ->
        msg =
          " #{@tab}#{@tab}#{param.name} #{
            "#{ansi_faint()}(#{param.type})#{ansi_normal()}#{
              if param.required, do: "#{ansi_faint()} (required)#{ansi_normal()}"
            }"
          }"

        IO.puts(msg)
      end)
    end

    if command_examples do
      IO.puts(" ")

      IO.puts(
        " #{@tab}#{@tab}#{ansi_bright()}#{
          if Enum.count(command_examples) <= 1, do: "example", else: "examples"
        }#{ansi_normal()}"
      )

      Enum.each(command_examples, fn example ->
        IO.puts(
          " #{@tab}#{@tab}#{example.command} #{ansi_faint()}# #{example.comment}#{
            ansi_normal()
          }"
        )
      end)
    end
  end

  defp ansi_bright, do: IO.ANSI.bright()
  defp ansi_faint, do: IO.ANSI.faint()
  defp ansi_normal, do: IO.ANSI.normal()
end
