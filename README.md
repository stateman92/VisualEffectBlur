# VisualEffectBlur
UIVisualEffectView's vibrancy has got into SwiftUI! 🏆

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/VisualEffectBlur", exact: .init(1, 0, 6))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Usage

```swift
import SwiftUI
import VisualEffectBlur

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VisualEffectBlur(blurStyle: .systemUltraThinMaterial, vibrancyStyle: .fill) {
                Text("Hello World!")
                    .font(.largeTitle)
            }
        }
        .ignoresSafeArea()
    }
}
```

For details see the Example app.

## Example

<p style="text-align:center;"><img src="https://github.com/stateman92/VisualEffectBlur/blob/main/Resources/screenshot.png?raw=true" width="50%" alt="Example"></p>
