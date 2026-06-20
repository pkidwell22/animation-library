// AnimationBrowserApp.swift
// SwiftUI app that browses all animations in the library.
// Run as a standalone macOS app or embed in a larger SwiftUI app.

import SwiftUI

@main
struct AnimationBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            AnimationBrowserView()
                .frame(minWidth: 800, minHeight: 600)
        }
    }
}

// MARK: - Main browser view

struct AnimationBrowserView: View {
    @State private var selectedTab: AnimationCategory = .unicode
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Animation Library")
                    .font(.headline)
                Spacer()
                Text("\(totalAnimations) animations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Tab bar
            Picker("Category", selection: $selectedTab) {
                ForEach(AnimationCategory.allCases) { cat in
                    Text(cat.label).tag(cat)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Filter by name...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(6)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            // Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: 1)], spacing: 1) {
                    ForEach(filteredItems, id: \.name) { item in
                        AnimationCard(item: item)
                    }
                }
            }
            .background(Color(nsColor: .separatorColor))
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var totalAnimations: Int {
        AnimationCategory.allCases.reduce(0) { $0 + $1.items.count }
    }

    private var filteredItems: [AnimationItem] {
        let items = selectedTab.items
        if searchText.isEmpty { return items }
        return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}

// MARK: - Animation card

struct AnimationCard: View {
    let item: AnimationItem

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.semibold)
                Spacer()
                if let cat = item.hermesCategory {
                    Text(cat)
                        .font(.system(size: 8, weight: .bold))
                        .textCase(.uppercase)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            cat == "thinking" ? Color.purple.opacity(0.2) :
                            cat == "tool" ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2)
                        )
                        .foregroundStyle(
                            cat == "thinking" ? Color.purple :
                            cat == "tool" ? Color.blue : Color.gray
                        )
                        .cornerRadius(2)
                }
            }

            // Animation preview
            item.view
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.05))
                .cornerRadius(4)

            // Meta
            HStack {
                Text(item.meta)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(12)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

// MARK: - Data model

enum AnimationCategory: String, CaseIterable, Identifiable {
    case unicode
    case native

    var id: String { rawValue }

    var label: String {
        switch self {
        case .unicode: return "Unicode Spinners"
        case .native: return "Native Loaders"
        }
    }

    var items: [AnimationItem] {
        switch self {
        case .unicode: return UnicodeItems.all
        case .native: return NativeItems.all
        }
    }
}

struct AnimationItem: Identifiable {
    let id = UUID()
    let name: String
    let hermesCategory: String?
    let meta: String
    let view: AnyView
}

// MARK: - Unicode items

enum UnicodeItems {
    static let all: [AnimationItem] = {
        let spinners = SpinnerLoader.fallbackSpinners
        return spinners.keys.sorted().map { name in
            let data = spinners[name]!
            let cat = SpinnerCategory.category(for: name)
            return AnimationItem(
                name: name,
                hermesCategory: cat == "other" ? nil : cat,
                meta: "\(data.frames.count) frames · \(Int(data.interval))ms",
                view: AnyView(SpinnerView(name: name, spinners: spinners))
            )
        }
    }()
}

// MARK: - Native items

enum NativeItems {
    static let all: [AnimationItem] = {
        NativeLoader.names.map { name in
            AnimationItem(
                name: name,
                hermesCategory: nil,
                meta: "native SwiftUI",
                view: AnyView(NativeLoader.view(for: name))
            )
        }
    }()
}