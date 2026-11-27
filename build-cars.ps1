# Reads images\cars\<category>\<car folder>\info.txt and writes cars-data.js
$root = Join-Path $PSScriptRoot "images\cars"
$out  = Join-Path $PSScriptRoot "cars-data.js"
$groups = @(
  @{path="family";            g="family";   sub=$null;       type="Family car"},
  @{path="everyday";          g="everyday"; sub=$null;       type="Everyday car"},
  @{path="business\transport";g="business"; sub="transport"; type="Transport vehicle"},
  @{path="business\trucks";   g="business"; sub="trucks";    type="Truck"}
)
function Num($v) { $d = "$v" -replace '[^\d]', ''; if ($d) { [int]$d } else { 0 } }
$cars = @()
foreach ($grp in $groups) {
  $p = Join-Path $root $grp.path
  if (-not (Test-Path $p)) { continue }
  foreach ($dir in (Get-ChildItem $p -Directory | Sort-Object Name)) {
    $info = @{}
    $f = Join-Path $dir.FullName "info.txt"
    if (Test-Path $f) {
      Get-Content $f | ForEach-Object { if ($_ -match '^\s*([^=#]+?)\s*=\s*(.*)$') { $info[$matches[1].Trim().ToLower()] = $matches[2].Trim() } }
    }
    $year = 0; $make = ($dir.Name -split ' ')[0]
    if ($dir.Name -match '^(\d{4})\s+(\S+)') { $year = [int]$matches[1]; $make = $matches[2] }
    $type = if ($info['type']) { $info['type'] } else { $grp.type }
    $base = "images/cars/" + ($grp.path -replace '\\', '/') + "/" + $dir.Name + "/"
    $files = @(Get-ChildItem $dir.FullName -File | Where-Object { $_.Extension -match '^\.(jpg|jpeg|png|webp)$' } | Sort-Object @{Expression={ if ($_.BaseName -eq 'main') { 0 } else { 1 } }}, Name | ForEach-Object { $base + $_.Name })
    $first = if ($files.Count -gt 0) { $files[0] } else { $base + "main.jpg" }
    $cars += [ordered]@{
      g = $grp.g; sub = $grp.sub; type = $type; name = $dir.Name; make = $make; year = $year
      km = (Num $info['km']); bf = (Num $info['price']); m = (Num $info['sold_month']); y = (Num $info['sold_year'])
      color = $info['color']; transmission = $info['transmission']; fuel = $info['fuel']; engine = $info['engine']; seats = $info['seats']; desc = $info['description']
      img = $first; imgs = [string[]]$files
    }
  }
}
$json = if ($cars.Count -eq 0) { "[]" } else { ConvertTo-Json -InputObject @($cars) -Depth 3 }
function Read-Info($path) {
  $h = @{}
  $f = Join-Path $path "info.txt"
  if (Test-Path $f) { Get-Content $f | ForEach-Object { if ($_ -match '^\s*([^=#]+?)\s*=\s*(.*)$') { $h[$matches[1].Trim().ToLower()] = $matches[2].Trim() } } }
  return $h
}
# Delivered clients: images\delivered\<one folder per delivery>, plus any loose photos
$exts = '^\.(jpg|jpeg|png|webp)$'
$delRoot = Join-Path $PSScriptRoot "images\delivered"
$del = @()
if (Test-Path $delRoot) {
  # loose photos become their own delivery folder, and every delivery folder gets an info.txt to fill in
  foreach ($f in (Get-ChildItem $delRoot -File | Where-Object { $_.Extension -match $exts })) {
    $nd = Join-Path $delRoot $f.BaseName
    if (-not (Test-Path $nd)) { New-Item -ItemType Directory -Path $nd | Out-Null }
    Move-Item $f.FullName (Join-Path $nd ("photo" + $f.Extension.ToLower()))
  }
  foreach ($d in (Get-ChildItem $delRoot -Directory)) {
    $t = Join-Path $d.FullName "info.txt"
    if (-not (Test-Path $t)) { Set-Content -Path $t -Value "client=`r`ncity=`r`ndate=`r`ncar=`r`nquote=" }
  }
  foreach ($dir in (Get-ChildItem $delRoot -Directory | Sort-Object Name -Descending)) {
    $info = Read-Info $dir.FullName
    $vexts = '^\.(mp4|webm|m4v)$'
    $files = @(Get-ChildItem $dir.FullName -File | Where-Object { $_.Extension -match $exts -or $_.Extension -match $vexts } | Sort-Object @{Expression={ if ($_.BaseName -in @('photo','main')) { 0 } elseif ($_.Extension -match $vexts) { 2 } else { 1 } }}, Name)
    $media = @($files | ForEach-Object { [ordered]@{ t = $(if ($_.Extension -match $vexts) { 'vid' } else { 'img' }); src = "images/delivered/" + $dir.Name + "/" + $_.Name } })
    $img = $null
    $firstPic = $files | Where-Object { $_.Extension -match $exts } | Select-Object -First 1
    if ($firstPic) { $img = "images/delivered/" + $dir.Name + "/" + $firstPic.Name }
    $del += [ordered]@{ client = $info['client']; city = $info['city']; car = $info['car']; date = $info['date']; quote = $info['quote']; img = $img; media = $media }
  }
  foreach ($f in (Get-ChildItem $delRoot -File | Where-Object { $_.Extension -match $exts } | Sort-Object Name)) {
    $del += [ordered]@{ client = $null; city = $null; car = $null; date = $null; quote = $null; img = "images/delivered/" + $f.Name; media = @() }
  }
}
$djson = if ($del.Count -eq 0) { "[]" } else { ConvertTo-Json -InputObject @($del) -Depth 3 }
[System.IO.File]::WriteAllText($out, "window.CARS_DATA = $json;`r`nwindow.DELIVERED_DATA = $djson;`r`n", (New-Object System.Text.UTF8Encoding $false))
Write-Host "Found $($cars.Count) cars and $($del.Count) delivered entries. cars-data.js updated."
