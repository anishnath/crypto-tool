Place the single-thread FFmpeg core files here so they are served from the same origin:

Required files (must be from the same core version):
- ffmpeg-core.js
- ffmpeg-core.wasm
- ffmpeg-core.worker.js

Recommended pairing with @ffmpeg/ffmpeg@0.11.6:
- Use @ffmpeg/core@0.11.1 single-thread build.

How to obtain:
1) From a local Node project (if available):
   - npm i @ffmpeg/core@0.11.1
   - Copy node_modules/@ffmpeg/core/dist/ffmpeg-core.* into this folder

2) Or download from the CDN and save locally (if accessible):
   - https://unpkg.com/@ffmpeg/core@0.11.1/dist/ffmpeg-core.js
   - https://unpkg.com/@ffmpeg/core@0.11.1/dist/ffmpeg-core.wasm
   - https://unpkg.com/@ffmpeg/core@0.11.1/dist/ffmpeg-core.worker.js

Notes:
- All three files must be present in this folder.
- The JS sets corePath to 'js/ffmpeg/ffmpeg-core.js', so relative imports will resolve to the .wasm and worker next to it.
- After placing the files, hard refresh (Shift+Reload) to bypass cache.
