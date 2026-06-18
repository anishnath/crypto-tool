/**
 * Parametric Electronics Enclosure
 * @category Practical / 3D Printing
 * @skillLevel 2
 * @description Box with lid, rounded corners, screw posts, and ventilation slots
 * @tags enclosure, box, electronics, 3d-printing, parametric
 */

const jscad = require('@jscad/modeling')
const { cuboid, cylinder, roundedCuboid } = jscad.primitives
const { union, subtract } = jscad.booleans
const { translate } = jscad.transforms
const { colorize } = jscad.colors

const getParameterDefinitions = () => [
  { name: 'innerW', type: 'float', initial: 60, min: 20, max: 200, step: 5, caption: 'Inner width (mm):' },
  { name: 'innerD', type: 'float', initial: 40, min: 20, max: 200, step: 5, caption: 'Inner depth (mm):' },
  { name: 'innerH', type: 'float', initial: 25, min: 10, max: 100, step: 5, caption: 'Inner height (mm):' },
  { name: 'wall', type: 'float', initial: 2.0, min: 1.0, max: 5.0, step: 0.5, caption: 'Wall thickness (mm):' },
  { name: 'cornerR', type: 'float', initial: 3.0, min: 0.5, max: 10, step: 0.5, caption: 'Corner radius (mm):' },
  { name: 'showLid', type: 'checkbox', checked: true, caption: 'Show lid' },
  { name: 'vents', type: 'checkbox', checked: true, caption: 'Add ventilation slots' }
]

const main = (params) => {
  const { innerW, innerD, innerH, wall, cornerR, showLid, vents } = params
  const outerW = innerW + wall * 2
  const outerD = innerD + wall * 2
  const outerH = innerH + wall

  // Outer shell
  const outer = roundedCuboid({ size: [outerW, outerD, outerH], roundRadius: cornerR, segments: 16 })
  // Inner cavity
  const inner = roundedCuboid({ size: [innerW, innerD, innerH], roundRadius: Math.max(cornerR - wall, 0.5), segments: 16 })
  let box = subtract(
    translate([0, 0, outerH / 2], outer),
    translate([0, 0, outerH / 2 + wall], inner)
  )

  // Screw posts (4 corners)
  const postR = 3
  const postH = innerH - 2
  const holeR = 1.25
  const offX = innerW / 2 - postR - 1
  const offY = innerD / 2 - postR - 1
  const corners = [[offX, offY], [-offX, offY], [-offX, -offY], [offX, -offY]]
  corners.forEach(([cx, cy]) => {
    const post = cylinder({ radius: postR, height: postH, segments: 20 })
    const hole = cylinder({ radius: holeR, height: postH + 2, segments: 16 })
    box = union(box, translate([cx, cy, wall + postH / 2], post))
    box = subtract(box, translate([cx, cy, wall + postH / 2 - 1], hole))
  })

  // Ventilation slots
  if (vents) {
    const slotW = 1.5
    const slotH = innerH * 0.5
    const slotCount = Math.floor(innerW / 5)
    const startX = -(slotCount - 1) * 2.5
    for (let i = 0; i < slotCount; i++) {
      const slot = cuboid({ size: [slotW, wall + 2, slotH] })
      box = subtract(box, translate([startX + i * 5, outerD / 2, outerH / 2 + 2], slot))
      box = subtract(box, translate([startX + i * 5, -outerD / 2, outerH / 2 + 2], slot))
    }
  }

  const parts = [colorize([0.3, 0.3, 0.35], box)]

  // Lid
  if (showLid) {
    const lidH = wall + 1.5
    const lidOuter = roundedCuboid({ size: [outerW, outerD, lidH], roundRadius: cornerR, segments: 16 })
    // Lip that fits inside the box
    const lip = roundedCuboid({ size: [innerW - 0.4, innerD - 0.4, 1.5], roundRadius: Math.max(cornerR - wall, 0.5), segments: 16 })
    const lid = union(
      translate([0, 0, lidH / 2], lidOuter),
      translate([0, 0, -0.75 + lidH / 2], lip)
    )
    parts.push(colorize([0.4, 0.4, 0.45], translate([0, 0, outerH + 3], lid)))
  }

  return parts
}

module.exports = { main, getParameterDefinitions }
