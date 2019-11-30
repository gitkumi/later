# Later
Log it now, do it later. Todo list on your terminal written on Elixir.

## Requirements

You need Elixir.

## Installation

1. Clone the repo.

2. `cd` into the project directory.
   
3. Build the project.
- `MIX_ENV=prod mix escript.build` This will generate a bin file. 

4. Install the generated bin.
- `mix escript.install /path/to/project/later/later`

5. It will be installed on `/home/user/.mix/escripts`

6. Add `/home/user/.mix/escripts` to your `$PATH` variable to run the program anywhere.

7. Run `later -h` to see how to use it.

## FAQ

1. Why is this not written on Go or Python?!?!
- I don't know Go or Python.

2. You mean to say I need Elixir on my machine to run this program!?!?
- Technically only Erlang/OTP, but yes.