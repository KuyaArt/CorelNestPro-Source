# CorelNest Pro — Milestone 1: Geometry Engine

This source package is the first implementation milestone, not yet a complete CorelDRAW plugin. It contains a dependency-free .NET 8 geometry library and a console verification harness.

## Implemented
- Polygon model, bounds, translation, centroid rotation and normalization.
- Point-in-polygon, segment intersection, polygon overlap, point/segment and polygon distance.
- Polygon containment for the initial Part-In-Part workflow.
- Convex NFP forbidden-region calculation using the Minkowski sum `A + (-B)`.
- Deterministic single-sheet bottom-left placement heuristic, rotation sampling over 0–360°, and exact polygon-distance recheck.

## Explicit limitations
- ConvexNfp currently accepts convex polygons only. Concave polygons are currently given vertex-alignment candidate seeds and exact collision checks; this is NOT a complete concave NFP implementation.
- `AllowPartInsidePart` currently permits full polygon containment. It does not yet model arbitrary holes as interior usable regions, multiple rings, islands, or toolpath lead-in constraints.
- Rotation is sampled at `360 / ceil(360 / RotationStepDegrees)` increments; it is not a mathematically continuous search. Set step to 1 for fine angular sampling.
- Nesting is single-sheet and heuristic. It is not a global optimum guarantee. Material remnant reuse and multi-sheet scheduling are future milestones.
- Input polygons must be simple, non-self-intersecting outer rings. Curve flattening, hole/ring extraction, and Corel COM integration are not included in this milestone.

## Build and run
Install .NET 8 SDK on Windows 10 x64. From this folder:

```powershell
dotnet build .\src\CorelNest.Geometry\CorelNest.Geometry.csproj -c Release
dotnet run --project .\tests\CorelNest.Geometry.Tests\CorelNest.Geometry.Tests.csproj -c Release
```

No NuGet dependencies are required for this milestone.

## Coordinate convention
Geometry coordinates use millimetres, X right, Y up. The Corel bridge must convert Corel document units and page coordinate orientation into this convention before calling the engine, then convert placed coordinates back.

## Next milestone
Implement curve-to-polygon conversion and compound paths (outer rings + holes), concave polygon decomposition, concave NFP union, then the CorelDRAW COM adapter and modeless UI. Do not enable production cutting until those features and a larger regression suite are verified.


## Important geometry limitation (Milestone 1)

A `Polygon2D` currently represents one solid outer ring. It does not yet represent holes/void rings.
Therefore `AllowPartInsidePart` must not bypass collision for ordinary contained polygons: a smaller
part inside a larger solid part is not physically nestable. The engine now always enforces clearance
between these single-ring solids. True Part-Inside-Part placement requires the upcoming compound
polygon model with explicit hole rings and toolpath-aware containment checks.
