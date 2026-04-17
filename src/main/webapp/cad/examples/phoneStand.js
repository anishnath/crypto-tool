/**
 * Parametric Phone/Tablet Stand
 * @category Practical / 3D Printing
 * @skillLevel 1
 * @description Adjustable phone stand with viewing angle parameter
 * @tags phone, stand, holder, 3d-printing, parametric
 */

const jscad = require('@jscad/modeling')
const { cuboid, roundedCuboid } = jscad.primitives
const { subtract, union } = jscad.booleans
const { translate, rotateX } = jscad.transforms
const { colorize } = jscad.colors

const getParameterDefinitions = () => [
  { name: 'angle', type: 'float', initial: 65, min: 30, max: 85, step: 5, caption: 'Viewing angle (deg):' },
  { name: 'width', type: 'float', initial: 80, min: 40, max: 150, step: 5, caption: 'Stand width (mm):' },
  { name: 'depth', type: 'float', initial: 60, min: 30, max: 100, step: 5, caption: 'Base depth (mm):' },
  { name: 'baseH', type: 'float', initial: 5, min: 3, max: 10, step: 1, caption: 'Base height (mm):' },
  { name: 'slotW', type: 'float', initial: 12, min: 8, max: 20, step: 1, caption: 'Slot width (mm):' },
  { name: 'lipH', type: 'float', initial: 15, min: 8, max: 30, step: 2, caption: 'Front lip height (mm):' }
]

const main = (params) => {
  const { width, depth, baseH, slotW, lipH } = params
  const angleRad = params.angle * Math.PI / 180

  // Base platform
  const base = roundedCuboid({ size: [width, depth, baseH], roundRadius: 2, segments: 16 })

  // Back rest (angled)
  const backH = 60
  const backT = 4
  const back = cuboid({ size: [width, backT, backH] })
  const backAngled = rotateX(Math.PI / 2 - angleRad,
    translate([0, 0, backH / 2], back)
  )

  // Phone slot
  const slot = cuboid({ size: [width + 2, slotW, baseH + 4] })
  const slotPos = translate([0, -depth / 2 + slotW / 2 + 5, baseH / 2], slot)

  // Front lip
  const lip = roundedCuboid({ size: [width, 5, lipH], roundRadius: 1.5, segments: 8 })
  const lipPos = translate([0, -depth / 2 + 2.5 + 5, lipH / 2], lip)

  let stand = union(
    translate([0, 0, baseH / 2], base),
    translate([0, depth / 2 - 2, baseH], backAngled),
    lipPos
  )
  stand = subtract(stand, slotPos)

  return colorize([0.2, 0.5, 0.7], stand)
}

module.exports = { main, getParameterDefinitions }
