# Google Sheets Integration for Xano

Read, write, and append data to Google Sheets spreadsheets directly from your Xano workflows.

## Functions

| Function | Description |
| --- | --- |
| `gsheets_read_range` | Reads values from a specified range in a Google Sheets spreadsheet. |
| `gsheets_append_rows` | Appends one or more rows of data to a Google Sheets spreadsheet. |

## Install

### Option A — Ask Claude Code

With the [Xano MCP](https://github.com/xano-labs/mcp-server) enabled in Claude Code, paste this into Claude:

> Install the integration at https://github.com/xano-community/integration-google-sheets into my Xano workspace.

Claude will clone the repo and push the functions to your workspace.

### Option B — Use the Xano CLI

1. Install and authenticate the [Xano CLI](https://docs.xano.com/cli):
   ```sh
   npm install -g @xano/cli
   xano auth
   ```

2. Clone and push this integration:
   ```sh
   git clone https://github.com/xano-community/integration-google-sheets.git
   cd integration-google-sheets
   xano workspace:push . -w <your-workspace-id>
   ```

   Replace `<your-workspace-id>` with the ID from `xano workspace:list`.

## Configure Credentials

1. Go to the Google Cloud Console (console.cloud.google.com) and create a project.
2. Enable the Google Sheets API for your project.
3. Create OAuth 2.0 credentials and complete the consent flow to obtain an access token.
4. In your Xano workspace, set the environment variable GOOGLE_SHEETS_ACCESS_TOKEN to your OAuth access token.

Environment variables used by this integration:

- `GOOGLE_SHEETS_ACCESS_TOKEN`

See `.env.example` for a template.

## Usage

Call any function from another function, task, or API endpoint using `function.run`:

```xs
function.run "gsheets_read_range" {
  input = {
    // See function signature for required parameters
  }
} as $result
```

## Function Reference

### `gsheets_read_range`

Retrieves cell values from a given spreadsheet range using the spreadsheet ID and A1 notation. Returns the data as a two-dimensional array of rows and columns. Useful for pulling live data from shared spreadsheets into your Xano backend for processing or display.

### `gsheets_append_rows`

Adds new rows to the end of a specified range in a spreadsheet. Accepts an array of row data and writes it after the last occupied row. Ideal for logging events, collecting form submissions, or syncing records from your Xano database to a shared spreadsheet.

## License

MIT — see [LICENSE](./LICENSE).
