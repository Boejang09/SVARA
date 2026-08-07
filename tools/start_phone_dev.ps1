param(
  [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" |
  Sort-Object RouteMetric, InterfaceMetric |
  Select-Object -First 1

$ip = $null
if ($defaultRoute) {
  $ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRoute.InterfaceIndex |
    Where-Object { $_.IPAddress -notlike "127.*" } |
    Select-Object -First 1 -ExpandProperty IPAddress
}

if (-not $ip) {
  $ip = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
      $_.IPAddress -notlike "127.*" -and
      $_.PrefixOrigin -ne "WellKnown" -and
      $_.InterfaceAlias -notmatch "Loopback|Virtual|VMware|Hyper-V|Bluetooth"
    } |
    Select-Object -First 1 -ExpandProperty IPAddress
}

if (-not $ip) {
  throw "Tidak menemukan IP Wi-Fi/LAN laptop. Pastikan laptop terhubung ke jaringan yang sama dengan HP."
}

Write-Host ""
Write-Host "SVARA Flutter web dev server"
Write-Host "Laptop : http://localhost:$Port"
Write-Host "HP     : http://$ip`:$Port"
Write-Host ""
Write-Host "Pastikan HP dan laptop berada di Wi-Fi yang sama."
Write-Host "Tekan q di terminal Flutter untuk berhenti."
Write-Host ""

flutter run -d web-server --web-hostname 0.0.0.0 --web-port $Port
