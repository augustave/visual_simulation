# XR Visual Language — "Command & Control" Design System

## Overview

The Command & Control (C2) visual language is the design system for all simulation and
interactive interfaces produced by this skill. It bridges military-grade information
density with consumer-grade usability.

This reference is **tool-agnostic** — token values and design rules are defined as
universal constants. Export formats for specific tools are provided at the end of each
section.

## Design Principles

1. **Glanceability**: Any data point must be comprehensible in <500ms of gaze fixation.
2. **Layered density**: Information is organized into disclosure layers — the user zooms
   in for detail, not scrolls.
3. **Environmental adaptability**: UI must remain legible against bright outdoor scenes,
   dark indoor environments, and dynamic lighting transitions.
4. **Muscle memory**: Interaction patterns are consistent across all modules. Same gesture
   = same action, everywhere.

## Color Palette — C2 Tokens

### Primary Palette (dark environment)

| Token name | Hex | Usage |
|---|---|---|
| `c2-bg-primary` | `#0A0E14` | Panel backgrounds |
| `c2-bg-secondary` | `#141B24` | Elevated surfaces |
| `c2-bg-glass` | `rgba(10,14,20,0.72)` | Floating panels (with blur) |
| `c2-text-primary` | `#E6EDF3` | Primary text, labels |
| `c2-text-secondary` | `#8B949E` | Secondary labels, metadata |
| `c2-accent-blue` | `#58A6FF` | Interactive elements, links |
| `c2-accent-green` | `#3FB950` | Nominal / OK status |
| `c2-accent-amber` | `#D29922` | Warning state |
| `c2-accent-red` | `#F85149` | Critical / danger state |
| `c2-accent-cyan` | `#39D2C0` | Measurement overlays, dimension lines |
| `c2-border-default` | `rgba(230,237,243,0.12)` | Panel borders |

### Light / Outdoor Override

When the environment is bright (sunlit exterior, light UI mode):

| Token name | Override hex |
|---|---|
| `c2-bg-glass` | `rgba(255,255,255,0.82)` |
| `c2-text-primary` | `#1C2128` |
| `c2-text-secondary` | `#57606A` |
| `c2-border-default` | `rgba(28,33,40,0.15)` |

Accent colors remain unchanged — they are already high-contrast against both backgrounds.

### Multi-Tool Token Export

**CSS Custom Properties:**
```css
:root {
  --c2-bg-primary: #0A0E14;
  --c2-bg-secondary: #141B24;
  --c2-bg-glass: rgba(10,14,20,0.72);
  --c2-text-primary: #E6EDF3;
  --c2-text-secondary: #8B949E;
  --c2-accent-blue: #58A6FF;
  --c2-accent-green: #3FB950;
  --c2-accent-amber: #D29922;
  --c2-accent-red: #F85149;
  --c2-accent-cyan: #39D2C0;
  --c2-border-default: rgba(230,237,243,0.12);
}
```

**SCSS Variables:**
```scss
$c2-bg-primary: #0A0E14;
$c2-accent-blue: #58A6FF;
// ... same pattern for all tokens
```

**JSON (for Figma plugin import, Unity, Three.js, or any config-driven tool):**
```json
{
  "c2-bg-primary": { "value": "#0A0E14", "type": "color" },
  "c2-accent-blue": { "value": "#58A6FF", "type": "color" },
  "c2-accent-red": { "value": "#F85149", "type": "color" }
}
```

**Figma Variables:** Create a collection called "C2 Tokens" with two modes: "Dark" and
"Light". Map each token name to a color variable. Use the override table for Light mode.

**Tailwind config:**
```js
theme: {
  extend: {
    colors: {
      'c2-bg': { primary: '#0A0E14', secondary: '#141B24' },
      'c2-text': { primary: '#E6EDF3', secondary: '#8B949E' },
      'c2-accent': { blue: '#58A6FF', green: '#3FB950', amber: '#D29922', red: '#F85149', cyan: '#39D2C0' },
    }
  }
}
```

**Three.js:**
```js
const C2 = {
  bgPrimary: new THREE.Color(0x0A0E14),
  accentBlue: new THREE.Color(0x58A6FF),
  accentRed: new THREE.Color(0xF85149),
};
```

Use whichever export format matches the user's tool. Generate additional formats on request.

## Typography

| Role | Font | Size (angular) | Size (px at 20PPD) | Size (CSS rem at 16px base) |
|---|---|---|---|---|
| HUD label | Inter Medium | 1.2° | 24px | 1.5rem |
| Panel title | Inter SemiBold | 1.6° | 32px | 2rem |
| Data readout | JetBrains Mono | 1.2° | 24px | 1.5rem |
| Warning text | Inter Bold | 2.0° | 40px | 2.5rem |
| Callout tag | Inter Medium | 1.0° | 20px | 1.25rem |

**Angular sizing** is the canonical spec (resolution-independent). The px and rem
columns are convenience conversions for screen-based tools. For Figma, use px. For
CSS/React, use rem. For XR engines, compute from angular size × PPD.

For print contexts, map to mm using the minimum sizes in `references/s1000d-rules.md`.

## Spatial UI Grid

### Panel Layout Zones

```
┌─────────────────────────────────────────────────┐
│  HEADER BAR (persistent)                         │
│  System name / Mission clock / Status indicators │
├──────────┬────────────────────────┬──────────────┤
│          │                        │              │
│  LEFT    │   CENTER VIEWPORT      │   RIGHT      │
│  NAV     │   (3D scene or        │   DETAIL     │
│  PANEL   │    primary content)    │   PANEL      │
│          │                        │              │
├──────────┴────────────────────────┴──────────────┤
│  TRAY (context actions / tools)                  │
└─────────────────────────────────────────────────┘
```

**Implementation by tool:**

- **Figma**: Use auto-layout frames. Header = fixed height, hug contents. Side panels =
  fill height, fixed width. Center = fill both. Tray = fixed height.
- **CSS/React**: CSS Grid with `grid-template-areas`. Header/tray = fixed rows. Side
  panels = fixed columns. Center = `1fr`.
- **Unity**: UI Toolkit flex containers or anchored RectTransforms.
- **XR/VR**: Header fixed at top of FOV (max 4° angular height). Side panels collapsible.
  Center viewport: panels must not occlude more than 35% at any time.

### Floating Panels (for 3D / spatial contexts)

Panels anchored to components in the scene:

- Leader line: 0.5px `c2-accent-cyan`, from panel corner to component surface
- Max distance from component: 2m world-space (or equivalent screen offset in 2D)
- Auto-fade at distance in 3D contexts; progressive disclosure on hover/click in 2D

## Interaction Patterns

These are the canonical interaction semantics. Map to the user's platform:

| Semantic action | XR/VR | Desktop/Web | Mobile/Touch | Figma prototype |
|---|---|---|---|---|
| Select component | Gaze + Dwell (1.5s) | Click | Tap | Click |
| Confirm / Activate | Pinch | Double-click or Enter | Long press | Click |
| Rotate model | Two-hand drag | Click + drag (or orbit control) | Two-finger rotate | N/A (use scroll) |
| Scale / Zoom | Two-hand spread | Scroll wheel | Pinch zoom | Scroll |
| Open context menu | Palm up | Right click | Long press | N/A |
| Dismiss panel | Swipe left | Escape or click × | Swipe away | N/A |
| Toggle exploded view | Voice: "Explode" | Keyboard shortcut | Button | Toggle component |
| Advance procedure step | Voice: "Next step" | Arrow key / button | Swipe or button | Click |

**Feedback constants** (implement in whatever system the user is building):

| Feedback | Specification |
|---|---|
| Selection highlight | 2px outline, `c2-accent-blue` |
| Hover state | 1px outline, `c2-accent-blue` at 50% opacity |
| Active/pressed | Background fill, `c2-accent-blue` at 15% opacity |
| Danger highlight | Pulsing fill, `c2-accent-red`, 1.2Hz, opacity 10%–35% |
| Transition duration | 200ms ease-out (panels), 800ms spring (exploded view) |

## Shader / Material Presets

These define the visual treatment of 3D surfaces. Adapt to the user's rendering context:

### Holographic / Tactical (default sim mode)

```json
{
  "preset": "c2_holographic",
  "base_material": {
    "albedo": "from_source_or_neutral_gray_#808080",
    "metallic": 0.3,
    "roughness": 0.6
  },
  "wireframe_overlay": {
    "color": "c2-accent-cyan",
    "opacity": 0.15,
    "width": 0.5
  },
  "selection_outline": {
    "color": "c2-accent-blue",
    "width": 2.0
  },
  "hazard_zone": {
    "color": "c2-accent-red",
    "mode": "pulsing_fill",
    "frequency_hz": 1.2,
    "opacity_range": [0.1, 0.35]
  }
}
```

**Tool mappings:**
- **Three.js**: `MeshStandardMaterial` + custom shader for wireframe overlay
- **Unity**: Standard shader + outline post-process + pulsing emission script
- **CSS (2D representation)**: `box-shadow` for glow, `outline` for selection, CSS
  animation for pulsing hazard zones
- **Figma**: Component variants for each state (default, selected, hazard)

### X-Ray / Maintenance Preview

```json
{
  "preset": "c2_xray",
  "base_material": {
    "opacity": 0.2,
    "color": "c2-text-secondary"
  },
  "focus_component": {
    "opacity": 1.0,
    "highlight_color": "c2-accent-green"
  }
}
```

## Performance Budgets

Specify targets appropriate to the user's platform:

| Platform | Poly budget | Draw calls | Texture res | Target FPS |
|---|---|---|---|---|
| Mobile XR (Quest 3, Pico) | 30k | <80 | 1024² | 72 |
| PC VR (Varjo, Index) | 80k | <150 | 2048² | 90 |
| Desktop web (Three.js) | 100k | <200 | 2048² | 60 |
| Large-format screen | 200k | <300 | 4096² | 60 |
| Figma / 2D | N/A | N/A | Vector preferred | N/A |

For non-3D contexts (Figma, static SVG, print), performance budgets don't apply.
Focus instead on file size and rendering complexity.

## Mapping to Tech Pub Tokens

The C2 palette maps to the S1000D print palette for style guide unification:

| C2 Token | S1000D Print Equivalent | Mapping rationale |
|---|---|---|
| `c2-accent-red` | DANGER hatching (dense 45° red lines) | Same semantic: critical hazard |
| `c2-accent-amber` | CAUTION diamond icon + amber tint | Same semantic: equipment risk |
| `c2-accent-green` | Nominal (no special marking in print) | Green = OK in both contexts |
| `c2-accent-cyan` | Dimension / measurement lines (blue in print) | Same semantic: spatial reference |
| `c2-accent-blue` | Interactive callout circles (blue in print) | Same semantic: user action point |
