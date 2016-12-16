defmodule CSVSheetsBug do
  @moduledoc """
    To run just enter in "iex -S mix" mode
    then run: CSVSheetsBug.find_a_bug
  """
  alias NimbleCSV, as: CSV
  alias GoogleSheets.Loader.Docs

  """
    You can access the public sheet here: https://docs.google.com/spreadsheets/d/1xCTZkgwA4gYWJGnPUx_0J1WMBVxhJHreTnQwpUKMYlU/
  """
  @spreadsheet_url "https://spreadsheets.google.com/feeds/worksheets/1xCTZkgwA4gYWJGnPUx_0J1WMBVxhJHreTnQwpUKMYlU/public/basic"

  def find_a_bug do
    {:ok, version, worksheets} = Docs.load nil, :spreadsheet_id, [url: @spreadsheet_url]

    csv = get_sheets(worksheets)

    CSV.define(MyParser, separator: "\t", escape: "\"")

    Enum.each csv, fn(sheet) ->
      #HERE IS THE POINT
      csv_decode = MyParser.parse_string sheet
      IO.puts "csv_decode: #{inspect csv_decode}"

      Enum.each csv_decode, fn(raw_row) ->
        IO.puts "DONE! Raw row Csv decoded: #{inspect raw_row}"
      end
    end
  end

  defp get_sheets(worksheets) do
    for x <- worksheets do
      x.csv
    end
  end
end
