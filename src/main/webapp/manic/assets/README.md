# Bundled assets

This directory is Manic's production asset catalog. Files here are packaged
with releases and can be addressed from a `.manic` file with a stable
`asset:` URI, independent of the process working directory.

## Available assets

| URI | Type | Intended use |
|---|---|---|
| `asset:manic-logo.png` | PNG | The Manic mark in `image(...)` scenes or a Creator `logo=` field |
| `asset:models/manic-pyramid.obj` | geometry-only OBJ | A small generic pyramid for `model3` examples, prototypes, and spatial stories |

Both public assets were authored for this project and are covered by the
repository license. OBJ imports remain subject to Manic's file-size and
geometry limits. Files under `fonts/` are engine-internal and embedded into the
binary; they are not public `asset:` choices.

## Add another asset

1. Put it in a typed subdirectory such as `models/`, using a lowercase,
   descriptive filename.
2. Add its stable `asset:` URI to the table above and to the mdBook asset
   catalog.
3. Add or update a checked example that uses the URI. Do not make examples
   depend on an absolute path or their launch directory.
4. Keep imported models geometry-only. Do not add scripts, arbitrary shaders,
   or remote dependencies.
5. Run the full tests and mdBook build. The Linux, Docker, and playground
   pipelines copy the complete `assets/` tree, so no per-file deploy rule is
   required.

Ordinary filesystem paths are still accepted by `model3` for user-provided
models. A backend must provision those files itself; bundled assets should use
the `asset:` form.
