param(
  [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$buildRoot = Join-Path $projectRoot "build\web"

Set-Location $projectRoot

$listener = netstat -ano -p tcp |
  Select-String "0.0.0.0:$Port|127.0.0.1:$Port|192.168.*:$Port" |
  Select-Object -First 1

if ($listener) {
  $parts = ($listener.Line -split "\s+") | Where-Object { $_ }
  $pidToStop = [int]$parts[-1]
  Write-Host "Stopping existing server on port $Port (PID $pidToStop)..."
  Stop-Process -Id $pidToStop -Force
}

flutter build web

$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" |
  Sort-Object RouteMetric, InterfaceMetric |
  Select-Object -First 1

$ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRoute.InterfaceIndex |
  Where-Object { $_.IPAddress -notlike "127.*" } |
  Select-Object -First 1 -ExpandProperty IPAddress

Start-Process -FilePath python -ArgumentList "-m", "http.server", "$Port" -WorkingDirectory $buildRoot -WindowStyle Hidden

Write-Host ""
Write-Host "Build terbaru sudah disajikan untuk HP:"
Write-Host "http://$ip`:$Port"
Write-Host ""
Write-Host "Kalau HP masih menampilkan versi lama, lakukan hard refresh atau hapus cache tab browser."
