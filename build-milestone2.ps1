$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

Write-Host '== CorelNest Geometry build ==' -ForegroundColor Cyan
dotnet build .\src\CorelNest.Geometry\CorelNest.Geometry.csproj -c Release

Write-Host '== Geometry regression tests ==' -ForegroundColor Cyan
dotnet run --project .\tests\CorelNest.Geometry.Tests\CorelNest.Geometry.Tests.csproj -c Release

Write-Host '== CorelDRAW exporter build ==' -ForegroundColor Cyan
dotnet build .\src\CorelNest.Export\CorelNest.Export.csproj -c Release

Write-Host '== Publish x64 self-contained ==' -ForegroundColor Cyan
dotnet publish .\src\CorelNest.Export\CorelNest.Export.csproj -c Release -r win-x64 --self-contained true -o .\publish

Write-Host 'Milestone 2 build sequence completed.' -ForegroundColor Green
