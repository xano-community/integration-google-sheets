function "gsheets_read_range" {
  description = "Read values from a Google Sheets spreadsheet range"
  input {
    text spreadsheet_id { description = "Google Sheets spreadsheet ID (from URL)" }
    text range { description = "A1 notation range (e.g. Sheet1!A1:D10)" }
    text value_render_option?="FORMATTED_VALUE" { description = "How values are rendered: FORMATTED_VALUE, UNFORMATTED_VALUE, or FORMULA" }
    text major_dimension?="ROWS" { description = "Major dimension: ROWS or COLUMNS" }
  }
  stack {
    var $params { value = {} }
    var.update $params { value = $params|set_ifnotnull:"valueRenderOption":$input.value_render_option }
    var.update $params { value = $params|set_ifnotnull:"majorDimension":$input.major_dimension }

    api.request {
      url = "https://sheets.googleapis.com/v4/spreadsheets/" ~ $input.spreadsheet_id ~ "/values/" ~ ($input.range|url_encode)
      method = "GET"
      headers = ["Authorization: Bearer " ~ $env.GOOGLE_SHEETS_ACCESS_TOKEN, "Accept: application/json"]
      params = $params
      mock = {
        "reads range successfully": { response: { status: 200, result: { range: "Sheet1!A1:D3", majorDimension: "ROWS", values: [["Name", "Email", "Role"], ["Jane Doe", "jane@example.com", "Admin"], ["John Smith", "john@example.com", "User"]] } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "Google Sheets API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "reads range successfully" {
    input = { spreadsheet_id: "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms", range: "Sheet1!A1:D3" }
    expect.to_not_be_null ($response.values)
    expect.to_equal ($response.majorDimension) { value = "ROWS" }
  }
}