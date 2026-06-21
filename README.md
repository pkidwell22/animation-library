# Animation Library

A collection of open-source animation primitives for loading states, generating indicators, and UI feedback.

## Categories

| Directory | Description |
|-----------|-------------|
| `unicode/` | Braille-pattern spinner animations from [unicode-animations](https://github.com/gunnargray-dev/unicode-animations). 18 spinners as raw frame data (JSON), usable in any language or platform. |
| `swift/` | Native SwiftUI animations — 18 braille spinners via `TimelineView` + 9 native loaders (Circle, Dots, Bars, Orbit, Pulse, Wave, Gradient Ring, Grid Flip, Infinity). Zero dependencies. |
| `external/react-bits/` | [React Bits](https://github.com/DavidHDev/react-bits) — 134 animated React/TypeScript components (text animations, backgrounds, UI components, cursor effects). 4 variants each: JS-CSS, JS-TW, TS-CSS, TS-TW. |
| `ascii/` | ASCII-art loading animations and progress indicators (planned) |
| `lottie/` | Lottie JSON animations for web/mobile/native (planned) |
| `css/` | Pure CSS keyframe animations (planned) |
| `svg/` | SVG-based loaders and progress indicators (planned) |

## Usage

### Unicode spinners

Each spinner is a `{ frames: string[], interval: number }` object. Cycle through `frames` on a timer at `interval` ms.

**Browser (no dependencies):**
```html
<script src="unicode/spinners.js"></script>
<script>
  const s = Spinners.helix;
  let i = 0;
  setInterval(() => {
    document.getElementById('spinner').textContent = s.frames[i++ % s.frames.length];
  }, s.interval);
</script>
<span id="spinner" style="font-family: monospace"></span>
```

**Node.js / ESM:**
```js
import { helix, breathe, dna } from './unicode/spinners.js';
// or import everything:
import * as Spinners from './unicode/spinners.js';
```

**Python:**
```python
import json
with open('unicode/spinners.json') as f:
    spinners = json.load(f)
helix = spinners['helix']
# cycle: helix['frames'], helix['interval']
```

**Swift:**
```swift
// Load unicode/spinners.json and decode
struct Spinner: Codable {
    let frames: [String]
    let interval: Int
}
```

### Native SwiftUI loaders

**SwiftUI (macOS/iOS):**
```swift
// Braille spinner
SpinnerView(name: "helix")

// Native loader
CircleLoader(color: .blue)
BarsLoader(color: .accentColor)
OrbitLoader(color: .green)

// Inline spinner
InlineSpinner(name: "dna")
```

Files: `swift/Spinners.swift`, `swift/NativeLoaders.swift`, `swift/AnimationBrowserApp.swift`

### React Bits

134 animated React/TypeScript components in 4 categories:
- **TextAnimations** (23): BlurText, GlitchText, GradientText, ShinyText, DecryptedText, CountUp, etc.
- **Animations** (30): BlobCursor, ClickSpark, ElectricBorder, MetaBalls, Ribbons, StarBorder, etc.
- **Components** (36): AnimatedList, Carousel, Dock, Lanyard, Masonry, Stepper, etc.
- **Backgrounds** (45): Aurora, Beams, Galaxy, Iridescence, Particles, Silk, Threads, Waves, etc.

Install via shadcn CLI or copy from `external/react-bits/src/ts-default/`:
```bash
npx shadcn@latest add @react-bits/BlurText-TS-TW
```

Browse all at [reactbits.dev](https://reactbits.dev).

### Browse all animations

Open `unicode/browser.html` in any browser — 161 animations across 4 tabs:
- Unicode Spinners (18) — live braille animation previews
- Native Loaders (9) — live CSS previews of SwiftUI loaders
- React Bits (134) — component inventory with links to reactbits.dev
- All (161) — everything in one grid

## Hermes Desktop Categories

Hermes Agent uses these spinners from this library:

- **Thinking** (7): `helix`, `breathe`, `orbit`, `dna`, `waverows`, `snake`, `pulse`
- **Tool execution** (7): `cascade`, `scan`, `diagswipe`, `fillsweep`, `rain`, `columns`, `sparkle`

## License

- Unicode spinners: MIT (sourced from [unicode-animations](https://github.com/gunnargray-dev/unicode-animations) by Gunnar Gray)
- Native SwiftUI loaders: MIT
- Browser tool: MIT
- React Bits: MIT + Commons Clause (see `external/react-bits/LICENSE.md`) — free for personal and commercial use, but components themselves may not be sold, sublicensed, or redistributed standalone
- This collection: MIT