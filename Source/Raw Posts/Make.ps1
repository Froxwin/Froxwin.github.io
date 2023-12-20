#Requires -Version 7
[CmdletBinding()]
param(
  [string][parameter(Position = 0)][alias('s')]$src = $(throw "Provide path to source"),
  [string][parameter(Position = 1)][alias('o')]$output = $(throw "Provide path to destination")
)

$In = Get-Item $src

$Metadata = Get-Content $In -TotalCount 3
  | Select-Object -Skip 1
  | ForEach-Object { ConvertFrom-StringData -StringData $_ -Delimiter ':' }

$Params = (
  "--template=$((Get-Item ".\Layout.html").FullName)",
  "--defaults=$((Get-Item .\Config.yml -ErrorAction Stop).FullName)"
)

$ListItem = @"
  <li><span class="cmd">&emsp;&emsp;\item </span><a href="./$($Metadata.date).html">$($Metadata.date): $($Metadata.title)</a></li>
    <!--8008 Insert Here :3 8008-->
"@

pandoc.exe "$($In)" -o "$($output)" @Params #2>&1 | Out-Null

(Get-Content "../Posts/index.html") -replace "<!--8008 Insert Here :3 8008-->",$ListItem
  | Set-Content "../Posts/index.html"
