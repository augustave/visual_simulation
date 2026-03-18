# Unified Style Guide Schema

## Overview

The style guide is the bridge artifact — it ensures the VR simulation and the technical
publication speak the same visual language. This file defines the JSON schema for that
style guide, along with rules for resolving cross-pipeline conflicts.

## Schema

```json
{
  "$schema": "style-guide-v2",
  "project": {
    "name": "[Project / Platform Name]",
    "version": "[SemVer]",
    "generated": "[ISO 8601 timestamp]"
  },

  "color_tokens": {
    "[token-name]": {
      "xr_value": "[hex or rgba for screen rendering]",
      "print_value": "[CMYK or Pantone for print]",
      "grayscale_fallback": "[hex grayscale for B&W print]",
      "semantic": "[what this color means]",
      "usage": "[where this color appears]"
    }
  },

  "typography": {
    "[role-name]": {
      "xr_font": "[font family for screen]",
      "xr_size_angular": "[degrees of visual angle]",
      "print_font": "[font family for print]",
      "print_size_mm": "[mm at A4 scale]",
      "weight": "[CSS weight value]"
    }
  },

  "line_weights": {
    "[element-type]": {
      "xr_weight_px": "[pixels at 20 PPD]",
      "print_weight_mm": "[mm stroke width]",
      "style": "[solid|dashed|chain|dotted]",
      "dash_pattern": "[on,off in mm — null if solid]"
    }
  },

  "iconography": {
    "[icon-name]": {
      "semantic": "[meaning]",
      "xr_asset": "[path to SVG/PNG for XR]",
      "print_asset": "[path to B&W SVG for print]",
      "s1000d_mapping": "[S1000D warning type, if applicable]"
    }
  },

  "safety_markings": {
    "[hazard-type]": {
      "xr_treatment": {
        "color": "[token reference]",
        "animation": "[static|pulsing|none]",
        "overlay_mode": "[fill|outline|hatch]"
      },
      "print_treatment": {
        "hatching": "[pattern description]",
        "icon": "[icon reference]",
        "text_prefix": "[DANGER|WARNING|CAUTION]"
      },
      "parity_required": true
    }
  },

  "component_states": {
    "[state-name]": {
      "xr_shader_preset": "[shader preset name]",
      "print_line_style": "[line convention from s1000d-rules.md]",
      "description": "[when this state applies]"
    }
  }
}
```

## Token Naming Convention

All tokens use kebab-case with a namespace prefix:

- `c2-` → Command & Control (XR-origin tokens)
- `tp-` → Technical Publication (print-origin tokens)
- `shared-` → Tokens that are identical in both pipelines

Examples: `c2-accent-red`, `tp-outline-weight`, `shared-hazard-hv`

## Conflict Resolution Rules

When the XR pipeline and the print pipeline have conflicting requirements, resolve
using these priorities:

1. **Safety always wins.** If a safety marking is visible in one pipeline but not the
   other, add it to both. Never remove a safety marking to resolve a conflict.

2. **Print constrains color.** If a color token doesn't have a viable grayscale fallback,
   add a secondary differentiator (hatching, icon, text label) to the print version.
   Do not change the XR color.

3. **XR constrains density.** If a print layout has too many callouts for XR legibility,
   the XR version uses progressive disclosure (show on hover/gaze). The print version
   retains all callouts.

4. **Semantic meaning is invariant.** Red means danger in both pipelines. Green means
   nominal. Cyan means measurement. Never reassign semantic meaning between pipelines.

## Validation Checklist

Before finalizing the style guide, verify:

- [ ] Every `safety_markings` entry has `parity_required: true` and both `xr_treatment`
  and `print_treatment` are populated
- [ ] Every `color_tokens` entry has a `grayscale_fallback`
- [ ] Typography `print_size_mm` values are all ≥ 2.5mm
- [ ] Typography `xr_size_angular` values are all ≥ 1.0°
- [ ] No two tokens share the same `grayscale_fallback` value unless they also share
  the same `semantic` (otherwise they'd be indistinguishable in B&W print)
- [ ] All `s1000d_mapping` values reference valid S1000D warning types
- [ ] `component_states` includes at minimum: `default`, `selected`, `hazard`, `removed`

## Multi-Tool Export

The canonical style guide is JSON. From it, generate exports for the user's tool:

| Target tool | Export format | Notes |
|---|---|---|
| Figma | Figma Variables JSON (plugin import) | One collection, two modes (Dark/Light) |
| CSS / React | `:root` custom properties | Include both dark and light as separate rulesets or media query |
| SCSS / SASS | `$variable` declarations | Group by category (bg, text, accent) |
| Tailwind | `tailwind.config.js` `extend.colors` | Use nested object structure |
| Unity | ScriptableObject C# class or JSON | One asset per theme |
| Three.js | JS module exporting `THREE.Color` instances | Include material preset objects |
| Illustrator | ASE swatch file spec or JSON for plugin | Group by semantic category |
| General | JSON (the canonical format) | Always available as baseline |

When exporting, always include:
1. The token name (for cross-reference between tools)
2. The semantic meaning (so a new team member understands *why* this color exists)
3. Both dark and light values where applicable

## Example: Minimal Style Guide

```json
{
  "$schema": "style-guide-v2",
  "project": {
    "name": "Satellite Bus Alpha",
    "version": "1.0.0",
    "generated": "2026-02-17T00:00:00Z"
  },
  "color_tokens": {
    "shared-hazard-hv": {
      "xr_value": "#F85149",
      "print_value": "Pantone 485 C",
      "grayscale_fallback": "#333333",
      "semantic": "High voltage danger zone",
      "usage": "Hazard boundary outlines and fill overlays"
    },
    "shared-nominal": {
      "xr_value": "#3FB950",
      "print_value": "Pantone 361 C",
      "grayscale_fallback": "#999999",
      "semantic": "System OK / no action required",
      "usage": "Status indicators, completion markers"
    }
  },
  "safety_markings": {
    "high_voltage": {
      "xr_treatment": {
        "color": "shared-hazard-hv",
        "animation": "pulsing",
        "overlay_mode": "fill"
      },
      "print_treatment": {
        "hatching": "dense 45° red lines, 1mm spacing",
        "icon": "icon-danger-triangle",
        "text_prefix": "DANGER"
      },
      "parity_required": true
    }
  }
}
```
