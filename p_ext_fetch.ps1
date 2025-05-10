# This script parses the Reaper source code for P_EXT lines and outputs a Lua table with the function names as keys and an array of values as values.
# Make sure to run this script in your Reaper source code directory.

# can run this script from the command line with:
# & "$([System.IO.Path]::Combine($env:LOCALAPPDATA, 'nvim-data\lazy\nvk-reaper-defs\p_ext_fetch.ps1'))"

$results = @{}

Get-ChildItem -Recurse -File |
ForEach-Object {
    $lines = Get-Content $_.FullName
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match 'P_EXT:\s*([^''""]+)') {
            $p_ext_value = $matches[1] -split '\s+'  # Split into words
            
            # Remove empty strings from the values
            $p_ext_value = $p_ext_value | Where-Object { $_ -ne '' }

            # Search for r.<function> on the same line as the P_EXT match
            $function = ''
            if ($lines[$i] -match '\br\.(\w+)\b') {
                $function = $matches[1]
            }

            if ($function -ne '' -and $p_ext_value.Count -gt 0) {
                if (-not $results.ContainsKey($function)) {
                    $results[$function] = @()
                }
                $results[$function] += $p_ext_value
            }
        }
    }
}

# Start the Lua table declaration
$tableOutput = "return {" + [Environment]::NewLine

# Build the Lua table representation
$results.GetEnumerator() | ForEach-Object {
    $function = $_.Key
    $uniqueValues = $_.Value | Sort-Object -Unique
    $tableOutput += "    $function = {" + [Environment]::NewLine
    
    foreach ($value in $uniqueValues) {
        $tableOutput += "        '$value'," + [Environment]::NewLine
    }
    
    $tableOutput += "    }," + [Environment]::NewLine
}

# Close the Lua table
$tableOutput += "}" + [Environment]::NewLine

# Path to nvim config (change if using a different location)
$nvimConfigPath = Join-Path $env:USERPROFILE 'AppData\Local\nvim\reaper\p_ext_vals.lua'

# Write to the file
$tableOutput | Out-File -FilePath $nvimConfigPath -Encoding UTF8

Write-Host "Lua table written to $nvimConfigPath"
