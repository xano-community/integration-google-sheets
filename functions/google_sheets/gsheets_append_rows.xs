function "gsheets_append_rows" {
  description = "Append rows to a Google Sheets spreadsheet"
  input {
    text spreadsheet_id { description = "Google Sheets spreadsheet ID (from URL)" }
    text range { description = "A1 notation range to append to (e.g. Sheet1!A1)" }
    json values { description = "2D array of values to append, e.g. [['Name','Email'],['John','john@example.com']]" }
    text value_input_option?="USER_ENTERED" { description = "How input is interpreted: RAW or USER_ENTERED" }
    text insert_data_option?="INSERT_ROWS" { description = "How data is inserted: OVERWRITE or INSERT_ROWS" }
  }
  stack {
    api.request {
      url = "https://sheets.googleapis.com/v4/spreadsheets/" ~ $input.spreadsheet_id ~ "/values/" ~ ($input.range|url_encode) ~ ":append?valueInputOption=" ~ $input.value_input_option ~ "&insertDataOption=" ~ $input.insert_data_option
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.GOOGLE_SHEETS_ACCESS_TOKEN, "Content-Type: application/json"]
      params = {
        values: $input.values
      }
      mock = {
        "appends rows successfully": { response: { status: 200, result: { spreadsheetId: "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms", tableRange: "Sheet1!A1:C3", updates: { updatedRange: "Sheet1!A4:C5", updatedRows: 2, updatedColumns: 3, updatedCells: 6 } } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "Google Sheets API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "appends rows successfully" {
    input = { spreadsheet_id: "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms", range: "Sheet1!A1", values: [["Alice", "alice@example.com", "Editor"]] }
    expect.to_not_be_null ($response.updates)
    expect.to_equal ($response.updates.updatedRows) { value = 2 }
  }
}