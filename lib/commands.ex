defmodule Later.Commands do
  alias Later.Error
  alias Later.Command
  alias Later.Command.{Example, Parameter}

  # TODO: Add finished and search command
  # TODO: Allow todo editing of only description

  @commands [
    %Command{
      :name => :show,
      :type => :boolean,
      :alias => :s,
      :description => "Show all todos. ",
      :examples => [
        %Example{
          :command => "later -s",
          :comment => "Show all todos."
        },
        %Example{
          :command => "later -s 1",
          :comment => "Show todo #1."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => false,
          :type => :integer
        }
      ]
    },
    %Command{
      :name => :add,
      :type => :boolean,
      :alias => :a,
      :description => "Add a todo.",
      :examples => [
        %Example{
          :command => "later -a \"Take out the garbage.\"",
          :comment => "Add a todo with a title \"Take out the garbage.\""
        },
        %Example{
          :command => "later -a \"Pay for rent.\" \"Bank closes at 5PM.\"",
          :comment =>
            "Add a todo with a title \"Pay for rent.\" and a description \"Bank closes at 5PM.\""
        }
      ],
      :parameters => [
        %Parameter{
          :name => :title,
          :required => true,
          :type => :string
        },
        %Parameter{
          :name => :description,
          :required => false,
          :type => :string
        }
      ]
    },
    %Command{
      :name => :edit,
      :type => :boolean,
      :alias => :e,
      :description => "Edit a todo.",
      :examples => [
        %Example{
          :command => "later -e 1 \"Take out the garbage on Tuesday.\"",
          :comment => "Edit todo #1's title."
        },
        %Example{
          :command =>
            "later -e 1 \"Take out the garbage on Tuesday.\" \"Also disposed pet bottles\"",
          :comment => "Edit todo #1's title and todo #1's description."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => true,
          :type => :integer
        },
        %Parameter{
          :name => :title,
          :required => false,
          :type => :string
        },
        %Parameter{
          :name => :description,
          :required => false,
          :type => :string
        }
      ]
    },
    %Command{
      :name => :delete,
      :type => :boolean,
      :alias => :d,
      :description => "Delete a todo.",
      :examples => [
        %Example{
          :command => "later -d 1",
          :comment => "Delete todo #1."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => true,
          :type => :integer
        }
      ]
    },
    %Command{
      :name => :help,
      :type => :boolean,
      :alias => :h,
      :description => "Display help."
    }
  ]

  @options [
    # switches: Enum.map(@commands, fn c -> {c.name, c.type} end),
    strict: Enum.map(@commands, fn c -> {c.name, c.type} end),
    aliases: Enum.map(@commands, fn c -> {c.alias, c.name} end)
  ]

  def get_commands, do: @commands

  def parse_options(input) do
    {parsed, args, _invalid} = OptionParser.parse(input, @options)

    parsed
    |> parse_command()
    |> get_command()
    |> parse_args(args)
    |> merge_params()
    |> check_required_params()
    |> convert_params_type()
  end

  defp parse_command(list) do
    list
    |> Enum.map(fn {c, _true} -> c end)
    |> Enum.at(0)
  end

  defp get_command(command_name) do
    show = Enum.find(@commands, fn c -> c.name == :show end)
    Enum.find(@commands, show, fn c -> c.name == command_name end)
  end

  defp parse_args(%{:name => :help}, _args), do: :help

  defp parse_args(command, input_args) do
    params =
      command
      |> Map.get(:parameters)
      |> Enum.with_index()
      |> Enum.map(fn {args, index} ->
        %{
          args.name => Enum.at(input_args, index)
        }
      end)

    {command, params}
  end

  defp merge_params(:help), do: :help

  defp merge_params({command, params}),
    do: {command, Enum.reduce(params, fn current, acc -> Map.merge(current, acc) end)}

  defp check_required_params(:help), do: :help

  defp check_required_params({command, params}) do
    command
    |> Map.get(:parameters)
    |> Enum.filter(fn p -> p.required end)
    |> Enum.map(fn p -> p.name end)
    |> Enum.reject(fn param -> params[param] != nil end)
    |> case do
      [] ->
        {command, params}

      missing ->
        # Right now there's only 1 required params for each command.
        {:error, %Error{:reason => "Invalid command. Missing value: #{Enum.at(missing, 0)}"}}
    end
  end

  defp convert_params_type(:help), do: :help

  defp convert_params_type({:error, params}), do: {:error, params}

  defp convert_params_type({command, params}) do
    converted =
      for {key, val} <- params, val != nil, into: %{} do
        command_param =
          command
          |> Map.get(:parameters)
          |> Enum.find(fn p -> p.name == key end)

        case Map.get(command_param, :type) do
          :integer ->
            {key, String.to_integer(val)}

          _ ->
            {key, val}
        end
      end

    {command.name, converted}
  end
end
