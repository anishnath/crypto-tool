# PyCharge JS (CPU)

This folder contains a CPU-only JavaScript port of core pieces of `/Users/anish/junk/pycharge`.

## Module map

- `charge.js` ← `pycharge/charge.py`
- `functional.js` ← `pycharge/functional/functional.py`
- `potentials-and-fields.js` ← `pycharge/potentials_and_fields.py`
- `sources.js` ← `pycharge/sources.py`
- `simulate.js` ← `pycharge/simulate.py`
- `constants.js` + `vector3.js` are JS support modules
- `index.js` is a barrel export

## Notes

- This port is CPU-based and dependency-free.
- JAX autodiff is replaced with finite-difference derivatives.
- Function names are camelCase (`potentialsAndFields`, `emissionTime`, etc.).
- Returned structures are plain JS arrays/objects.

## Quick usage

```js
import {
  Charge,
  ELEMENTARY_CHARGE,
  potentialsAndFields,
} from './index.js';

const charge = new Charge(
  (timeValue) => [0.01 * Math.cos(timeValue), 0, 0],
  ELEMENTARY_CHARGE,
);

const fieldAt = potentialsAndFields([charge]);
const quantities = fieldAt(0.2, 0.1, 0.0, 1.0);
console.log(quantities.electric, quantities.magnetic);
```

