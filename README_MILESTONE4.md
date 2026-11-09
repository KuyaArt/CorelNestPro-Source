# CorelNest Pro — Milestone 4: CorelDRAW WPF Docker & Apply Layout

Target: Windows 10 x64, CorelDRAW Technical Suite 27, .NET Framework 4.8, .NET 8 runtime bundled self-contained for the nesting engine.

## Implemented in this milestone

- Native WPF UserControl Docker loaded through `Application.FrameWork.AddDocker`.
- Docker UI fields for sheet width/height, part spacing, border margin, rotation sampling, and curve tolerance.
- Preview action attaches to the running CorelDRAW process and exports selected geometry through the existing safe temporary-duplicate reader.
- The .NET 8 engine classifies compound contours and runs the Milestone 3 nesting kernel.
- Placement CSV is generated in invariant-culture numeric format.
- Apply action duplicates the selected source shapes, rotates each duplicate, then moves it to the computed location on the active page.
- Original source artwork is retained; generated copies are wrapped in a CorelDRAW command group for Undo.
- Engine is published self-contained for Windows x64; end users do not need to install the .NET 8 runtime separately.
- Session install/uninstall scripts register and show/hide the Docker through CorelDRAW's FrameWork API.

## Build on the target Windows machine

Requirements:
- Windows 10 x64
- CorelDRAW Technical Suite 27 installed
- .NET 8 SDK
- .NET Framework 4.8 Developer Pack (normally available with Visual Studio 2022)
- PowerShell 5.1+

From the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Build-Milestone4.ps1
```

The script runs geometry regression tests, publishes the self-contained engine, builds the WPF Docker, and creates:

`artifacts\CorelNestPro-Milestone4-Windows-x64.zip`

Extract the ZIP and double-click `Install-CorelNest.bat`. CorelDRAW should be open. The Docker appears in the current CorelDRAW session and can also be accessed from Window > Dockers. Use `Uninstall-CorelNest.bat` to remove it from the current session.

## Workflow

1. Open a document and select the closed vector objects to nest.
2. Open CorelNest Pro Docker.
3. Enter sheet size, part gap, border gap, rotation step and curve tolerance in mm/degrees.
4. Click **Analisis & Pratinjau Nesting**.
5. Review placed/unplaced counts and utilization.
6. Click **Terapkan ke Dokumen Corel**. The plugin creates positioned duplicates on the active page; it does not move or delete the source objects.
7. Inspect the result and use CorelDRAW Undo if needed.

## Known limitations — do not use as an unattended production cutter yet

- This is a single-sheet placement pass. Multi-sheet page creation and per-sheet optimization are not implemented in this milestone.
- Each selected Corel object must resolve to exactly one filled region (one outer contour plus zero or more holes). Objects containing multiple disconnected islands are skipped with a warning to avoid duplicating or losing artwork.
- The geometry kernel is heuristic. It samples rotation and candidate positions; it is not a globally optimal solver or full exact concave NFP implementation.
- Apply uses CorelDRAW COM `Duplicate`, `Rotate`, `GetBoundingBox`, and `Move`. Coordinate behavior must be verified on the target machine with a test document before production. The target is the active page's document origin plus the configured material margin.
- The Docker install script loads the Docker for the current CorelDRAW session. Automatic loading after a fresh CorelDRAW restart is not claimed; the .NET `.addon` startup contract has not been verified.
- A real host integration test is still required on the user's CorelDRAW installation. This development environment cannot run CorelDRAW or Windows COM and does not have the .NET SDK, so the Windows build and host execution must be performed on the target PC.

## Safety

The exporter duplicates selected shapes temporarily for curve conversion and deletes those temporary copies. Apply creates new duplicates and retains originals. Before production use, validate output dimensions, clearances, orientation, page coordinate origin, holes, and curves against physical test cuts.
