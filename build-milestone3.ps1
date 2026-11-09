$ErrorActionPreference = 'Stop'

Write-Host '== CorelNest Pro Milestone 3: build geometry ==' -ForegroundColor Cyan
dotnet build .\src\CorelNest.Geometry\CorelNest.Geometry.csproj -c Release
if ($LASTEXITCODE -ne 0) { throw 'Geometry build failed.' }

Write-Host '== Run geometry regression tests ==' -ForegroundColor Cyan
dotnet run --project .\tests\CorelNest.Geometry.Tests\CorelNest.Geometry.Tests.csproj -c Release
if ($LASTEXITCODE -ne 0) { throw 'Geometry tests failed.' }

Write-Host '== Build CorelDRAW exporter ==' -ForegroundColor Cyan
dotnet build .\src\CorelNest.Export\CorelNest.Export.csproj -c Release
if ($LASTEXITCODE -ne 0) { throw 'Exporter build failed.' }

Write-Host 'Milestone 3 build and tests completed.' -ForegroundColor Green
