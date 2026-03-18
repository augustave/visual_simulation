# S1000D Compliance Rules — Technical Illustration Pipeline

## Overview

S1000D is the international specification for the production of technical publications.
This reference covers the subset relevant to **technical illustrations and procedural
data modules** for hardware maintenance documentation.

All technical illustrations produced by this skill must conform to these rules. When in
doubt, favor clarity over aesthetics — these documents are used by technicians in
high-stress, low-light field conditions.

## Line Conventions

| Element | Stroke weight | Style | Color (print) |
|---|---|---|---|
| Component outline | 0.7mm | Solid | Black |
| Internal detail | 0.35mm | Solid | Black |
| Hidden geometry | 0.35mm | Dashed (2mm on, 1mm off) | Black |
| Section cut plane | 0.5mm | Chain (long-short-long) | Black |
| Dimension lines | 0.25mm | Solid with arrows | Black |
| Callout leader lines | 0.35mm | Solid with dot terminus | Black |
| Phantom / adjacent parts | 0.25mm | Long dash (4mm on, 2mm off) | 50% gray |

## Callout Format

Every callout in an exploded or detail view must follow this structure:

```
[Item Number] — [Part Name] (PN: [Part Number])
```

Example: `3 — Retaining Bracket (PN: 7204-0033-01)`

- Item numbers are sequential integers starting at 1
- Item numbers appear in a **balloon** (circle with leader line)
- Leader lines must not cross other leader lines where avoidable
- If crossing is unavoidable, the crossing line must have a small bridge/hop
- Balloons are placed outside the component boundary, never overlapping geometry

## Figure Metadata (XML)

Every illustration must be wrapped in an S1000D data module. Minimum required fields:

```xml
<figure id="fig-[sequential]">
  <title>[Descriptive Title]</title>
  <graphic infoEntityIdent="ICN-[project]-[figure-id]-001">
    <hotspot id="hs-[item-number]"
             apsName="[part-name]"
             apsNumber="[part-number]"
             applicationStructIdent="[system-code]"/>
    <!-- Repeat for each callout -->
  </graphic>
</figure>
```

### Data Module Code Structure

The DMC (Data Module Code) for illustrations follows:

```
DMC-[model]-[system]-[subsystem]-[unit]-[assembly]-[disassembly]-[variant]
```

For initial drafts, use placeholder codes and flag them with `[TBD]` for the user's
technical publications team to finalize.

## Warning / Caution / Note Blocks

S1000D defines a strict hierarchy for safety messaging. These MUST appear before the
procedural step they apply to, never after.

| Level | Icon | Usage |
|---|---|---|
| **DANGER** | ⚠ (triangle, filled) | Risk of death or serious injury |
| **WARNING** | ⚠ (triangle, outline) | Risk of injury or equipment damage |
| **CAUTION** | ◆ (diamond) | Risk of equipment damage only |
| **NOTE** | ℹ (circle) | Supplementary information |

XML structure:

```xml
<warningAndCautionRef>
  <warningRef id="warn-[sequential]" warningType="[danger|warning|caution]">
    <warningAndCautionPara>[Description of hazard and avoidance procedure]</warningAndCautionPara>
  </warningRef>
</warningAndCautionRef>
```

## View Types

| View | When to use | SVG requirements |
|---|---|---|
| **Isometric** | Orientation, general assembly overview | 30° projection, OML emphasis |
| **Exploded** | Disassembly/reassembly procedures | Components separated along removal axis, leader lines showing trajectory |
| **Cutaway** | Internal access, fluid paths, wiring routes | Section plane clearly marked, hatching per material type |
| **Detail inset** | Small fasteners, connectors, alignment marks | Magnified area circled in parent view, scale noted |
| **Schematic** | Electrical/hydraulic systems | Standard symbols per MIL-STD-15016 |

## Material Hatching (Cross-Section)

When showing cutaway or section views, use these standard hatch patterns:

| Material | Pattern |
|---|---|
| Metal (general) | 45° parallel lines, 2mm spacing |
| Aluminum | 45° parallel lines, 1mm spacing |
| Rubber/elastomer | 45° crossed lines (crosshatch) |
| Composite | Stipple dot pattern |
| Insulation | Wavy lines |
| Fluid/hydraulic | Horizontal lines |

## Common Validation Errors

| Error | Fix |
|---|---|
| `BREX-001: Missing hotspot for callout` | Every balloon callout needs a corresponding `<hotspot>` in XML |
| `BREX-002: Warning after step` | Move warning/caution block BEFORE the step it applies to |
| `BREX-003: Figure ID not referenced` | Every `<figure>` must be referenced by at least one `<internalRef>` in procedural text |
| `BREX-004: Part number format invalid` | Part numbers must match project naming convention (ask user) |
| `SCHEMA-001: Missing required attribute` | Check `infoEntityIdent` format: ICN-[project]-[figure]-[variant] |

## Print Constraints

- All illustrations must be legible at **A4 size** (210mm × 297mm)
- Minimum text height: **2.5mm** at print scale
- All color information is supplementary — the illustration must be fully comprehensible
  in **grayscale** and **monochrome photocopy**
- For color versions, use the safety color mapping from the unified style guide

## Tool-Agnostic Implementation

The line conventions and callout rules above are universal. Here's how to implement
them in different tools:

### SVG (raw or code-generated)

```xml
<!-- Component outline: 0.7mm = ~2.65px at 96 DPI -->
<path stroke="#000" stroke-width="2.65" fill="none" d="..." />

<!-- Internal detail: 0.35mm = ~1.32px -->
<path stroke="#000" stroke-width="1.32" fill="none" d="..." />

<!-- Hidden geometry: dashed -->
<path stroke="#000" stroke-width="1.32" stroke-dasharray="7.56,3.78" fill="none" d="..." />

<!-- Callout balloon -->
<circle cx="..." cy="..." r="12" stroke="#000" stroke-width="1.32" fill="white" />
<text x="..." y="..." font-size="10" text-anchor="middle" dominant-baseline="central">3</text>
<line x1="..." y1="..." x2="..." y2="..." stroke="#000" stroke-width="1.32" />
```

### Figma

- Create a "Tech Illustration" component set with stroke styles matching the weight table
- Use component properties for callout numbers (text swap)
- Leader lines: use connector-style lines or manual paths with 1.32px stroke
- Stroke weights: 0.7mm → 2.65px, 0.35mm → 1.32px, 0.25mm → 0.95px
- Create a "Dashed" stroke style for hidden geometry

### Adobe Illustrator / Affinity Designer

- Set document units to mm for direct spec compliance
- Create Graphic Styles matching each line convention
- Use Symbol libraries for callout balloons
- Create a "Tech Illustration" layer template with correct sublayers

### React / HTML

- Use inline SVG or a library like `react-svg-path` for programmatic generation
- Define stroke constants matching the weight table
- Callout data structure:

```js
const callouts = [
  { id: 1, label: "Retaining Bracket", pn: "7204-0033-01", x: 100, y: 200 },
];
```

### CSS (for web-based documentation viewers)

```css
.tech-illust-outline { stroke-width: 2.65px; stroke: #000; }
.tech-illust-detail { stroke-width: 1.32px; stroke: #000; }
.tech-illust-hidden { stroke-width: 1.32px; stroke: #000; stroke-dasharray: 7.56 3.78; }
.tech-illust-callout-leader { stroke-width: 1.32px; stroke: #000; }
.tech-illust-dimension { stroke-width: 0.95px; stroke: #000; }
```
