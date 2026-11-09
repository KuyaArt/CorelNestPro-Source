# CorelNest Pro — Milestone 3: Compound Contours & Hole-Aware Nesting

Target: CorelDRAW Technical Suite 27 / Windows x64 / .NET 8.

## Added in Milestone 3

- `ContourTopologyClassifier`: determines outer, hole, and island roles from a set of closed rings using a containment tree. Classification does not depend on winding direction.
- `PolygonRegion2D`: represents one filled outer contour with explicit void rings (holes), validates hole containment and rejects overlapping holes, and calculates material area.
- `CompoundGeometry2D`: tests whether a part fits fully inside a void with clearance and checks candidate-vs-material collision conservatively.
- `NestingPart.Holes` / `PlacedPart.Holes`: the nesting engine can now carry hole contours with the host part.
- Hole-aware candidate seeds: the nesting engine attempts to place smaller parts in available holes.
- Clearance is checked against the hole boundary; a part crossing the void boundary is not treated as a legal insert.
- Rotation sampling now follows the requested `RotationStepDegrees` increment (e.g. 5°, 10°, 15°) over [0, 360). This is sampled rotation, not continuous mathematical optimization.
- Utilization is calculated from net material area (outer area minus holes).
- Added regression tests for outer/hole/island classification, hole area, clearance, collision and a part-inside-hole nesting scenario.

## Important scope and limitations

1. The topology classifier operates on closed rings exported from CorelDRAW. The Corel bridge still exports rings independently; automatic classification must be called by the next integration layer before converting exported JSON into `NestingPart` objects.
2. `PolygonRegion2D` supports one outer boundary plus direct child holes. Islands inside holes are represented as separate regions by `ContourTopologyClassifier.BuildRegions`.
3. Concave polygons are collision-checked using polygon edges, but the candidate generator remains a heuristic vertex-alignment search. It is not a full exact concave NFP implementation and may miss valid placements.
4. Rotation is discretely sampled according to `RotationStepDegrees`; a 1° step approximates free rotation but can be computationally expensive. It is not continuous 0–360° optimization.
5. The geometry kernel does not yet perform a complete production-grade multi-sheet optimization, material grain constraints, or a visual panel in CorelDRAW.
6. CorelDRAW export and the COM bridge are unchanged from Milestone 2. This milestone does not yet move or duplicate the final nested artwork back into the document.
7. Geometry clearance uses the flattened polygon approximation. Set curve tolerance appropriately in the exporter to balance accuracy and speed.

## Build and regression tests (Windows with .NET 8 SDK)

```powershell
dotnet build .\src\CorelNest.Geometry\CorelNest.Geometry.csproj -c Release
dotnet run --project .\tests\CorelNest.Geometry.Tests\CorelNest.Geometry.Tests.csproj -c Release
dotnet build .\src\CorelNest.Export\CorelNest.Export.csproj -c Release
```

## Recommended settings

- For faster testing: rotation step 15°.
- For finer orientation search: 5° or 2°.
- For high-detail curved shapes: reduce exporter tolerance (e.g. 0.10 mm), then benchmark complexity.
- Always verify the output visually before cutting material.


## Fix 1 — clearance boundary regression

A regression in the first Milestone 3 package treated a part at exactly the requested clearance as colliding. This caused the pre-existing two-parts placement test to fail when `PartGap` was 2 mm. The compound collision predicate now accepts exact equality (for example, a measured 2.000 mm gap when 2 mm is requested), while still rejecting smaller gaps. Added regression tests cover both cases.
