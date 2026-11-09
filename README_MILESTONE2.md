# CorelNest Pro — Milestone 2: CorelDRAW Selection Bridge & Curve Converter

Target: CorelDRAW Technical Suite 27 / Windows x64 / .NET 8 SDK.

## What this milestone adds

- `CorelNest.Geometry.Geometry.CurveFlattener`: adaptive parametric curve flattening using quarter, midpoint and three-quarter deviation checks.
- `CorelNest.CorelBridge`: late-bound COM adapter; attaches to the running `CorelDRAW.Application.27` instance.
- Selection extraction from `ActiveSelectionRange`.
- Each selected object is duplicated temporarily, converted to curves, read through `Curve.SubPaths -> SubPath.Segments -> Segment.GetPointAt`, then the temporary duplicate is deleted. The original selected artwork is not converted or moved.
- Closed subpaths are exported as millimetre contours. Open paths are skipped with warnings.
- `CorelNest.Export`: command-line exporter to JSON.
- `build-milestone2.ps1`: build, regression-test and publish sequence.
- `vba/CorelNestBridge.bas`: optional VBA macro to launch the exporter from CorelDRAW.

## Important limitations

1. This milestone exports contours; it does not yet run nesting or move artwork back onto the page.
2. The JSON preserves each closed subpath and its winding. It does not yet classify nested rings as outer boundaries versus holes, and it does not model islands/multiple nesting levels. Therefore, do not treat Part-Inside-Part as production-ready yet.
3. The curve tolerance is an adaptive geometric approximation tolerance in millimetres, but the COM `GetPointAt` evaluator is sampled through the Corel API. Test circles, ellipses, text converted to curves, compound curves and rotated objects in the target Corel version.
4. Open paths are not suitable as filled nesting boundaries and are reported as warnings.
5. The COM adapter must run on Windows x64 with CorelDRAW 27 installed and already running. This project uses late binding, so it does not require manually adding a Corel type-library reference.
6. This environment did not have the .NET SDK or CorelDRAW installed; compilation and live COM integration must be verified on the user's Windows computer.

## Build

Open PowerShell in the `CorelNestPro` project root:

```powershell
dotnet build .\src\CorelNest.Geometry\CorelNest.Geometry.csproj -c Release
dotnet run --project .\tests\CorelNest.Geometry.Tests\CorelNest.Geometry.Tests.csproj -c Release
dotnet build .\src\CorelNest.Export\CorelNest.Export.csproj -c Release
```

Publish x64 self-contained:

```powershell
dotnet publish .\src\CorelNest.Export\CorelNest.Export.csproj -c Release -r win-x64 --self-contained true -o .\publish
```

The published executable is `publish\CorelNest.Export.exe`.

## Live CorelDRAW test

1. Start CorelDRAW Technical Suite 27 and open a document.
2. Draw a rectangle and an ellipse; select both. For a first test, use simple closed objects only.
3. Run:

```powershell
.\publish\CorelNest.Export.exe --export-selection "$env:TEMP\CorelNest_selection.json" --tolerance-mm 0.20
```

4. Confirm that the command reports the selected object count and creates the JSON file.
5. Open the JSON and check `objects[].contours[].points`. Every contour should have at least 3 points. The temporary duplicates must not remain in the document and original shapes must remain unchanged.

Optional: import `vba\CorelNestBridge.bas` in the CorelDRAW VBA editor, edit `CN_EXPORT_EXE` to the actual published EXE path, select shapes, and run `CN_ExportSelectedGeometry`.

## Coordinate contract

- Exported geometry is in millimetres.
- Each object contour is localized so its combined contour bounding box starts at `(0,0)`.
- `originalBoundsMm` records the original document-space bounding box in millimetres.
- The current exporter reports the Corel coordinate convention as X-right / Y-up. Verify orientation with a known rectangle in the target document before implementing placement write-back.

## Next milestone

- Compound polygon model: outer rings, holes, islands, containment hierarchy and fill-rule handling.
- Concave decomposition and concave NFP candidate generation.
- Nesting controller and placement write-back to CorelDRAW using `Shape.RotateEx` and `Shape.SetPosition` with explicit document reference-point/unit handling.
- Modeless UI with NEST / STOP / RESET.
