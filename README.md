# Visual Simulation Ops

This directory contains the `visual-systems-architect-simulation-ops` skill bundle.
It is built for hardware programs that need matched outputs across two lanes:

- simulation and immersive interface work such as XR/VR UI, digital twins, spatial dashboards, and real-time 3D overlays
- technical publication work such as S1000D-aligned illustrations, maintenance views, callouts, and unified style guides

The core constraint is consistency. A component, hazard marking, and visual token should
mean the same thing in the sim, the code, and the manual.

## What Is Here

- `SKILL.md`: the skill definition, operating protocol, triggers, and output contract
- `agents/openai.yaml`: UI metadata for listing and invoking the skill
- `agents/install_skill.sh`: installer that copies the skill into the local skill library, validates it, and regenerates the index
- `references/xr-visual-language.md`: command-and-control visual language for simulation outputs
- `references/s1000d-rules.md`: line, callout, and XML rules for technical illustration outputs
- `references/style-guide-schema.md`: schema for the shared style guide between sim and tech-pub artifacts

## When To Use It

Use this skill when a project needs one or more of the following:

- digital twin interfaces
- XR or command-and-control UI for physical systems
- exploded, cutaway, or maintenance illustrations
- S1000D-ready technical visual packages
- a shared design language across simulation and documentation
- a consistency audit between simulation outputs and manuals

Do not use it for generic marketing art, unconstrained concept illustration, or hardware
design changes that belong in engineering source data.

## Working Model

The skill can operate in three modes:

- `SIMULATION`: interactive or real-time visuals
- `TECHNICAL_DOCUMENTATION`: print-safe or standards-driven technical output
- `BOTH`: dual-pipeline delivery with cross-checks and unified tokens

If the tool context is not specified, the portable default is `SVG + HTML/CSS + JSON`.

## Install

From this directory:

```bash
./agents/install_skill.sh
```

The installer copies the bundle into the local high-assurance skill library at:

```text
/Users/taoconrad/Dev/SKILLS/high_assurance_agent_library/skills-core/visual-systems-architect-simulation-ops
```

Then it runs validation and updates the shared skills index.

## Example Requests

- "Build a digital twin and maintenance manual for this avionics bay."
- "Generate S1000D illustrations for this battery module."
- "Create XR UI and a shared style guide for this field repair workflow."
- "Audit whether our simulation visuals match our manual callouts."

## Notes

- Geometry is sourced from engineering truth, not from aesthetic preference.
- Safety markings must remain consistent across simulation and documentation outputs.
- If source material is incomplete, the skill is expected to stop and issue a redline request rather than invent geometry.
