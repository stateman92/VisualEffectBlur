/*
 Copyright © 2020 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import SwiftUI

#if os(iOS)
public struct VisualEffectBlur<Content: View>: View {
    private let blurStyle: UIBlurEffect.Style
    private let vibrancyStyle: UIVibrancyEffectStyle?
    private let content: () -> Content

    public init(
        blurStyle: UIBlurEffect.Style = .systemMaterial,
        vibrancyStyle: UIVibrancyEffectStyle? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.content = content
    }

    public var body: some View {
        Representable(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: ZStack { content() })
            .accessibility(hidden: Content.self == EmptyView.self)
    }
}

extension VisualEffectBlur {
    struct Representable<Content: View>: UIViewRepresentable {
        let blurStyle: UIBlurEffect.Style
        let vibrancyStyle: UIVibrancyEffectStyle?
        let content: Content

        func makeUIView(context: Context) -> UIVisualEffectView {
            context.coordinator.blurView
        }

        func updateUIView(_ view: UIVisualEffectView, context: Context) {
            context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }
    }
}

extension VisualEffectBlur.Representable {
    final class Coordinator {
        let blurView = UIVisualEffectView()
        private let vibrancyView = UIVisualEffectView()
        private let hostingController: UIHostingController<Content>

        init(content: Content) {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.view.backgroundColor = nil
            blurView.contentView.addSubview(vibrancyView)
            
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vibrancyView.contentView.addSubview(hostingController.view)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?) {
            hostingController.rootView = content

            let blurEffect = UIBlurEffect(style: blurStyle)
            blurView.effect = blurEffect

            vibrancyView.effect = vibrancyStyle.map { UIVibrancyEffect(blurEffect: blurEffect, style: $0) }

            hostingController.view.setNeedsDisplay()
        }
    }
}

extension VisualEffectBlur where Content == EmptyView {
    public init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.init(blurStyle: blurStyle, vibrancyStyle: nil) {
            EmptyView()
        }
    }
}
#endif
