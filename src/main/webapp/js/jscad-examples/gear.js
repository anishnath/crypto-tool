/**
 * Parametric Spur Gear
 * @category Mechanical Parts
 * @skillLevel 3
 * @description Parametric involute spur gear with configurable teeth, module, and thickness
 * @tags gear, mechanical, parametric, 3d-printing
 */

const jscad = require('@jscad/modeling')
const { cylinder, polygon } = jscad.primitives
const { extrudeLinear } = jscad.extrusions
const { union, subtract } = jscad.booleans
const { translate, rotateZ } = jscad.transforms
const { colorize } = jscad.colors

const getParameterDefinitions = () => [
  { name: 'teeth', type: 'int', initial: 20, min: 6, max: 60, step: 1, caption: 'Number of teeth:' },
  { name: 'module', type: 'float', initial: 2.0, min: 0.5, max: 5.0, step: 0.1, caption: 'Module (mm):' },
  { name: 'thickness', type: 'float', initial: 8.0, min: 2.0, max: 30.0, step: 1.0, caption: 'Thickness (mm):' },
  { name: 'boreDia', type: 'float', initial: 5.0, min: 1.0, max: 20.0, step: 0.5, caption: 'Bore diameter (mm):' },
  { name: 'pressureAngle', type: 'float', initial: 20, min: 14.5, max: 25, step: 0.5, caption: 'Pressure angle (deg):' }
]

const main = (params) => {
  const { teeth, thickness, boreDia } = params
  const m = params.module
  const pa = params.pressureAngle * Math.PI / 180

  const pitchR = (teeth * m) / 2
  const addendum = m
  const dedendum = 1.25 * m
  const outerR = pitchR + addendum
  const rootR = pitchR - dedendum

  // Build gear profile as a polygon (simplified involute approximation)
  const points = []
  const steps = teeth * 8
  for (let i = 0; i < steps; i++) {
    const angle = (i / steps) * Math.PI * 2
    const toothPhase = (i % 8) / 8

    let r
    if (toothPhase < 0.2) {
      r = rootR + (outerR - rootR) * (toothPhase / 0.2) // rising flank
    } else if (toothPhase < 0.3) {
      r = outerR // top
    } else if (toothPhase < 0.5) {
      r = outerR - (outerR - rootR) * ((toothPhase - 0.3) / 0.2) // falling flank
    } else {
      r = rootR // root
    }

    points.push([r * Math.cos(angle), r * Math.sin(angle)])
  }

  const profile = polygon({ points })
  const gear = extrudeLinear({ height: thickness }, profile)

  // Bore hole
  const bore = cylinder({ radius: boreDia / 2, height: thickness + 2, segments: 32 })

  return colorize([0.7, 0.7, 0.75], subtract(
    translate([0, 0, 0], gear),
    translate([0, 0, -1], bore)
  ))
}

module.exports = { main, getParameterDefinitions }
