// Spinners.swift
// Native SwiftUI port of unicode-animations braille spinners.
// Loads from spinners.json — same data as the JS/Python versions.
// Usage:
//   SpinnerView(name: "helix")
//   SpinnerView(name: "dna", color: .blue, fontSize: 24)

import SwiftUI

struct SpinnerData: Codable, Hashable {
    let frames: [String]
    let interval: Double  // milliseconds
}

enum SpinnerLoader {
    /// Load spinners from a bundled spinners.json in the app bundle
    static func load(from bundle: Bundle = .main) -> [String: SpinnerData] {
        guard let url = bundle.url(forResource: "spinners", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: SpinnerData].self, from: data) else {
            return fallbackSpinners
        }
        return decoded
    }

    /// Inline fallback — 18 spinners hardcoded so the package works without a JSON file
    static let fallbackSpinners: [String: SpinnerData] = [
        "braille": SpinnerData(frames: ["⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏"], interval: 80),
        "braillewave": SpinnerData(frames: ["⠁","⠈","⠐","⠠","⢀","⠠","⠐","⠈"], interval: 80),
        "dna": SpinnerData(frames: ["⠁⠂","⠈⠐","⠠⢀","⢀⠠","⠐⠈","⠂⠁","⠁⠂","⠈⠐","⠠⢀","⢀⠠","⠐⠈","⠂⠁"], interval: 100),
        "scan": SpinnerData(frames: ["⠁","⠈","⠐","⠠","⢀","⠠","⠐","⠈"], interval: 80),
        "rain": SpinnerData(frames: ["⠁","⠉","⠋","⠍","⠝","⠟","⠿","⠿","⠟","⠝","⠍","⠋","⠉","⠁"], interval: 80),
        "scanline": SpinnerData(frames: ["⠁","⠂","⠄","⡀","⢀","⠠","⠐","⠈"], interval: 60),
        "pulse": SpinnerData(frames: ["⠁","⠃","⠇","⠏","⠟","⠿","⠟","⠏","⠇","⠃","⠁"], interval: 80),
        "snake": SpinnerData(frames: ["⠁","⠉","⠋","⠧","⠜","⠔","⠐","⠠"], interval: 80),
        "sparkle": SpinnerData(frames: ["⠁","⠉","⠙","⠹","⠽","⠿","⠽","⠹","⠙","⠉"], interval: 80),
        "cascade": SpinnerData(frames: ["⠁","⠉","⠋","⠧","⠧","⠗","⠷","⠿","⠷","⠗","⠧","⠧","⠋","⠉","⠁"], interval: 80),
        "columns": SpinnerData(frames: ["⠁⠂⠄","⠂⠄⡀","⠄⡀⢀","⡀⢀⠠","⢀⠠⠐","⠠⠐⠈","⠐⠈⠁","⠈⠁⠂","⠁⠂⠄","⠂⠄⡀","⠄⡀⢀","⡀⢀⠠"], interval: 80),
        "orbit": SpinnerData(frames: ["⠁","⠉","⠙","⠹","⠽","⠿","⠷","⠶","⠦","⠴","⠔","⠐","⠠","⢀","⠠","⠐","⠔","⠴","⠦","⠶","⠷","⠿","⠽","⠹","⠙","⠉"], interval: 60),
        "breathe": SpinnerData(frames: ["⠁","⠉","⠋","⠛","⠟","⠿","⠿","⠟","⠛","⠋","⠉","⠁"], interval: 100),
        "waverows": SpinnerData(frames: ["⠁⠈","⠈⠁","⠉⠉","⠉⠉","⠉⠉","⠉⠉","⠈⠁","⠁⠈"], interval: 80),
        "checkerboard": SpinnerData(frames: ["⠉⠉⠉⠉","⠈⠈⠈⠈","⠁⠁⠁⠁","⠐⠐⠐⠐","⠠⠠⠠⠠","⢀⢀⢀⢀","⠠⠠⠠⠠","⠐⠐⠐⠐","⠁⠁⠁⠁","⠈⠈⠈⠈","⠉⠉⠉⠉","⠉⠉⠉⠉"], interval: 80),
        "helix": SpinnerData(frames: ["⢌⣉⢎⣉","⣉⡱⣉⡱","⣉⢎⣉⢎","⡱⣉⡱⣉","⢎⣉⢎⣉","⣉⡱⣉⡱","⣉⢎⣉⢎","⡱⣉⡱⣉","⢎⣉⢎⣉","⣉⡱⣉⡱","⣉⢎⣉⢎","⡱⣉⡱⣉","⢎⣉⢎⣉","⣉⡱⣉⡱","⣉⢎⣉⢎","⡱⣉⡱⣉"], interval: 80),
        "fillsweep": SpinnerData(frames: ["⠁","⠉","⠋","⠛","⠟","⠿","⠿","⠿","⠿","⠿","⠟","⠛","⠋","⠉","⠁"], interval: 60),
        "diagswipe": SpinnerData(frames: ["⠁⠂⠄⡀","⠂⠄⡀⢀","⠄⡀⢀⠠","⡀⢀⠠⠐","⢀⠠⠐⠈","⠁⠂⠄⡀","⠂⠄⡀⢀","⠄⡀⢀⠠"], interval: 80),
    ]
}

// MARK: - Hermes categories

enum SpinnerCategory {
    static let thinking = ["helix", "breathe", "orbit", "dna", "waverows", "snake", "pulse"]
    static let tool = ["cascade", "scan", "diagswipe", "fillsweep", "rain", "columns", "sparkle"]

    static func category(for name: String) -> String {
        if thinking.contains(name) { return "thinking" }
        if tool.contains(name) { return "tool" }
        return "other"
    }
}

// MARK: - Spinner View

struct SpinnerView: View {
    let name: String
    var color: Color = .accentColor
    var fontSize: CGFloat = 28

    @State private frameIndex: Int = 0
    private let data: SpinnerData

    init(name: String, color: Color = .accentColor, fontSize: CGFloat = 28, spinners: [String: SpinnerData]? = nil) {
        self.name = name
        self.color = color
        self.fontSize = fontSize
        let all = spinners ?? SpinnerLoader.fallbackSpinners
        self.data = all[name] ?? SpinnerData(frames: ["⠿"], interval: 80)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: data.interval / 1000.0)) { context in
            let idx = Int(context.date.timeIntervalSinceReferenceDate * (1000.0 / data.interval)) % data.frames.count
            Text(data.frames[idx])
                .font(.system(size: fontSize, weight: .regular, design: .monospaced))
                .foregroundStyle(color)
                .frame(minWidth: 40, minHeight: 40)
                .contentTransition(.identity)
        }
    }
}

// MARK: - Inline spinner (for text contexts)

struct InlineSpinner: View {
    let name: String
    var color: Color = .secondary
    var fontSize: CGFloat = 14

    @State private frameIndex: Int = 0
    private let data: SpinnerData

    init(name: String, color: Color = .secondary, fontSize: CGFloat = 14, spinners: [String: SpinnerData]? = nil) {
        self.name = name
        self.color = color
        self.fontSize = fontSize
        let all = spinners ?? SpinnerLoader.fallbackSpinners
        self.data = all[name] ?? SpinnerData(frames: ["⠿"], interval: 80)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: data.interval / 1000.0)) { context in
            let idx = Int(context.date.timeIntervalSinceReferenceDate * (1000.0 / data.interval)) % data.frames.count
            Text(data.frames[idx] + " ")
                .font(.system(size: fontSize, weight: .regular, design: .monospaced))
                .foregroundStyle(color)
        }
    }
}

// MARK: - Preview

#Preview("Spinner Gallery") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 24) {
            ForEach(Array(SpinnerLoader.fallbackSpinners.keys.sorted()), id: \.self) { name in
                VStack(spacing: 8) {
                    SpinnerView(name: name)
                    Text(name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(SpinnerCategory.category(for: name))
                        .font(.caption2)
                        .foregroundStyle(SpinnerCategory.category(for: name) == "thinking" ? .purple :
                                         SpinnerCategory.category(for: name) == "tool" ? .blue : .gray)
                }
            }
        }
        .padding()
    }
}