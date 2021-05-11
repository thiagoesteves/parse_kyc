defmodule Parse.Kyc do
  @moduledoc """
  synopsis:
    This script is going to parse an html page from KYC. In order to collect the html, visit
    https://edoc.identitymind.com/reference#kyc-1 and click in the target command. After,
    press F12 to inspect the element in Google Chrome, copy the body and paste in a file
    (e. g. test.txt).

    Once you have the html saved, inspect the command you want to parse. To do it,
    click in the command (https://edoc.identitymind.com/reference#create-1) and
    inspect the first element of "Body Params", e.g., man :
    It belongs to <fieldset id=body-create>, the target "id" is: body-create

  usage:
    ./bin/parse_kyc --id "body-create" --filename "test.txt"
  options:
    --filename File with the html contents
    --id       fieldset that will be parsed
  """

  def main([help_opt]) when help_opt == "-h" or help_opt == "--help" do
    IO.puts(@moduledoc)
  end

  @spec main([binary]) :: :ok
  def main(args) do
    args
    |> parse_args
    |> execute
  end

  defp parse_args(args) do
    {opts, _value, _} =
      args
      |> OptionParser.parse(switches: [id: :string, filename: :string])

    opts
  end

  defp execute(opts) do
    filename = opts[:filename] || nil
    id = opts[:id] || nil

    unless filename do
      IO.puts("filename required")
      System.halt(0)
    end

    unless id do
      IO.puts("id required")
      System.halt(0)
    end

    run(filename, id)
  end

  defp run(filename, id) do
    IO.puts("Parsing the file #{filename} for the id: #{id}")

    [{"fieldset", [{"id", _}], new_list}] =
      File.read!(filename)
      |> Floki.parse_document!()
      |> Floki.find("fieldset#" <> id)

    map =
      Enum.reduce(
        new_list,
        %{},
        fn
          {"div", [{"class", _}],
           [
             {"span", _,
              [
                {"label", _, [name]},
                {"span", _, [type]},
                {"div", _, [{_, [_, _], [{_, _, [description]}]}]}
              ]}
             | _
           ]},
          acc ->
            acc
            |> Map.put(String.to_atom(name), %{
              value: get_default_type(type),
              description: description
            })

          {"div", [{"class", _}],
           [
             {"span", _,
              [
                {"label", _, [name]},
                {"span", _, [type]},
                {"div", _, [{_, [_, _], [{_, _, [description1 | description2]}]}]}
              ]}
             | _
           ]},
          acc ->
            description = inspect(description1) <> inspect(description2)

            acc
            |> Map.put(String.to_atom(name), %{
              value: get_default_type(type),
              description: description
            })

          {"div", [{"class", _}],
           [
             {"span", _,
              [
                {"label", _, [name]},
                {"span", _, [type]},
                {"div", _, [{_, [_, _], []}]}
              ]}
             | _
           ]},
          acc ->
            acc
            |> Map.put(String.to_atom(name), %{value: get_default_type(type), description: ""})

          _y, acc ->
            acc
        end
      )

    IO.puts("@#{id} #{inspect(map, limit: :infinity)}")
    :ok
  end

  defp get_default_type("string"), do: ""

  defp get_default_type("array of strings"), do: []

  defp get_default_type("int64"), do: "0"

  defp get_default_type("int32"), do: "0"

  defp get_default_type("boolean"), do: "false"

  defp get_default_type("double"), do: "0.0"

  defp get_default_type("object"), do: DateTime.utc_now() |> DateTime.to_iso8601()
end
