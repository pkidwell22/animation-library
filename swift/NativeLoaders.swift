// NativeLoaders.swift
// Curated native SwiftUI loading animations — no dependencies.
// Ported/inspired by SwiftfulLoadingIndicators, open-swiftui-animations, SpinKit.
// Usage:
//   CircleLoader()
//   WaveLoader()
//   BarsLoader()
//   OrbitLoader()
//   ShimmerView(text: "Generating...")
//   DotsLoader()

import SwiftUI

// MARK: - Rotating Arcs (SpinKit-style)

struct CircleLoader: View {
    var color: Color = .accentColor
    var lineWidth: CGFloat = 4
    var size: CGFloat = 44

    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Bouncing Dots

struct DotsLoader: View {
    var color: Color = .accentColor
    var dotSize: CGFloat = 8
    var spacing: CGFloat = 6

    @State private var offset: CGFloat = 0

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: i == 1 ? -offset : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                offset = dotSize * 1.5
            }
        }
    }
}

// MARK: - Wave Bars (equalizer style)

struct BarsLoader: View {
    var color: Color = .accentColor
    var barCount: Int = 5
    var barWidth: CGFloat = 4
    var maxHeight: CGFloat = 28
    var minHeight: CGFloat = 6

    @State private var animated = false

    var body: some View {
        HStack(spacing: barWidth / 2) {
            ForEach(0..<barCount, id: \.self) { i in
                RoundedRectangle(cornerRadius: barWidth / 2)
                    .fill(color)
                    .frame(width: barWidth, height: animated ? maxHeight : minHeight)
                    .animation(
                        .easeInOut(duration: 0.4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.1),
                        value: animated
                    )
            }
        }
        .onAppear { animated = true }
    }
}

// MARK: - Orbit Loader (planetary)

struct OrbitLoader: View {
    var color: Color = .accentColor
    var size: CGFloat = 44
    var dotSize: CGFloat = 6

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.25), lineWidth: 1.5)
                .frame(width: size, height: size)
            Circle()
                .fill(color)
                .frame(width: dotSize, height: dotSize)
                .offset(x: size / 2)
        }
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Pulse Ring

struct PulseLoader: View {
    var color: Color = .accentColor
    var size: CGFloat = 40

    @State private var pulsing = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 2)
                .scaleEffect(pulsing ? 1.0 : 0.5)
                .opacity(pulsing ? 0 : 1)
            Circle()
                .fill(color)
                .frame(width: size * 0.3, height: size * 0.3)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).repeatForever(autoreverses: false)) {
                pulsing = true
            }
        }
    }
}

// MARK: - Wave Loader (sin path)

struct WaveLoader: View {
    var color: Color = .accentColor
    var width: CGFloat = 60
    var height: CGFloat = 20
    var waveCount: Int = 3

    @State private var phase: Double = 0

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.03)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                var path = Path()
                let step: Double = 2
                let amplitude = size.height * 0.3
                let centerY = size.height / 2

                for x in stride(from: 0, through: size.width, by: step) {
                    let relX = Double(x) / Double(size.width)
                    let y = amplitude * sin(relX * .pi * Double(waveCount) * 2 + t * 4) + centerY
                    if x == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                ctx.stroke(path, with: .color(color), lineWidth: 2)
            }
            .frame(width: width, height: height)
        }
    }
}

// MARK: - Gradient Ring

struct GradientRingLoader: View {
    var size: CGFloat = 44
    var lineWidth: CGFloat = 4

    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(
                AngularGradient(
                    colors: [.blue, .purple, .pink, .blue],
                    center: .center
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Square Grid (flip animation)

struct GridFlipLoader: View {
    var color: Color = .accentColor
    var squareSize: CGFloat = 10
    var spacing: CGFloat = 3

    @State private var flip = false

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<2, id: \.self) { col in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(color)
                            .frame(width: squareSize, height: squareSize)
                            .rotation3DEffect(
                                .degrees(flip ? 180 : 0),
                                axis: (x: 1, y: 1, z: 0)
                            )
                            .animation(
                                .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(row * 2 + col) * 0.12),
                                value: flip
                            )
                    }
                }
            }
        }
        .onAppear { flip = true }
    }
}

// MARK: - Shimmer

struct ShimmerView: View {
    var text: String = "Loading"
    var color: Color = .secondary

    @State private var phase: CGFloat = -1

    var body: some View {
        Text(text)
            .foregroundStyle(color)
            .redacted(reason: .placeholder)
            .shimmering(phase: phase)
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// Shimmer modifier
struct ShimmerModifier: ViewModifier {
    var phase: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * geo.size.width * 1.6)
                    .blendMode(.plusLighter)
                }
                .mask(content)
            )
    }
}

extension View {
    func shimmering(phase: CGFloat) -> some View {
        modifier(ShimmerModifier(phase: phase))
    }
}

// MARK: - Infinity Loader

struct InfinityLoader: View {
    var color: Color = .accentColor
    var size: CGFloat = 44

    @State private var trimEnd: CGFloat = 0

    var body: some View {
        Path { path in
            let w = size
            let h = size * 0.5
            let r = h * 0.5
            let centerY = h * 0.5

            path.addEllipse(in: CGRect(x: 0, y: centerY - r, width: h, height: h))
            path.addEllipse(in: CGRect(x: w - h, y: centerY - r, width: h, height: h))
        }
        .trim(from: 0, to: trimEnd)
        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        .frame(width: size, height: size * 0.5)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                trimEnd = 1
            }
        }
    }
}

// MARK: - Loader registry

enum NativeLoader {
    static let names: [String] = [
        "Circle", "Dots", "Bars", "Orbit", "Pulse",
        "Wave", "Gradient Ring", "Grid Flip", "Infinity"
    ]

    @ViewBuilder
    static func view(for name: String, color: Color = .accentColor) -> some View {
        switch name {
        case "Circle": CircleLoader(color: color)
        case "Dots": DotsLoader(color: color)
        case "Bars": BarsLoader(color: color)
        case "Orbit": OrbitLoader(color: color)
        case "Pulse": PulseLoader(color: color)
        case "Wave": WaveLoader(color: color)
        case "Gradient Ring": GradientRingLoader()
        case "Grid Flip": GridFlipLoader(color: color)
        case "Infinity": InfinityLoader(color: color)
        default: CircleLoader(color: color)
        }
    }
}

// MARK: - Preview

#Preview("Native Loaders") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 24) {
            ForEach(NativeLoader.names, id: \.self) { name in
                VStack(spacing: 8) {
                    NativeLoader.view(for: name)
                        .frame(height: 50)
                    Text(name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
}