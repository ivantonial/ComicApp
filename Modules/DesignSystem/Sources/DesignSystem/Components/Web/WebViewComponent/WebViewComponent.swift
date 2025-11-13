//
//  WebViewComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 06/11/25.
//

import SwiftUI
import WebKit

/// Componente reutilizável para exibir conteúdo HTML
/// com tema escuro, apenas scroll vertical e título opcional.
public struct WebViewComponent: UIViewRepresentable {

    // MARK: - Shared Process Pool
    /// Compartilha um único processPool para reduzir consumo de memória e churn de processos.
    private static let sharedProcessPool = WKProcessPool()

    // MARK: - Inputs
    private let htmlContent: String
    private let title: String?
    private let baseURL: URL?
    private let backgroundColor: UIColor
    private let textColor: String
    private let fontSize: Int
    private let maxImages: Int

    /// - Parameters:
    ///   - htmlContent: HTML bruto (body) a ser exibido.
    ///   - title: Título opcional a ser exibido centralizado no topo (ex: nome do personagem).
    ///   - baseURL: URL base para links relativos (opcional).
    ///   - backgroundColor: Cor de fundo do WebView (default: preto).
    ///   - textColor: Cor do texto em formato CSS (default: branco `#FFFFFF`).
    ///   - fontSize: Tamanho base da fonte em px (default: 16).
    ///   - maxImages: Limite de `<img>` para evitar OOM (default: `Int.max` = sem limite).
    public init(
        htmlContent: String,
        title: String? = nil,
        baseURL: URL? = nil,
        backgroundColor: UIColor = .black,
        textColor: String = "#FFFFFF",
        fontSize: Int = 16,
        maxImages: Int = Int.max
    ) {
        self.htmlContent = htmlContent
        self.title = title
        self.baseURL = baseURL
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.fontSize = fontSize
        self.maxImages = maxImages
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = Self.sharedProcessPool
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        configuration.allowsInlineMediaPlayback = true

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        preferences.javaScriptEnabled = true
        configuration.preferences = preferences

        // JS que promove imagens lazy (data-src/srcset) e cria <img> a partir de figure[data-img-src]
        let lazyImagesJS = """
        (function() {
          function promoteLazy() {
            document.querySelectorAll('img[data-src]').forEach(function(img){
              var src = img.getAttribute('data-src'); if (src) { img.setAttribute('src', src); }
            });
            document.querySelectorAll('img[data-srcset]').forEach(function(img){
              var ss = img.getAttribute('data-srcset'); if (ss) { img.setAttribute('srcset', ss); }
            });
            document.querySelectorAll('source[data-srcset]').forEach(function(s){
              var ss = s.getAttribute('data-srcset'); if (ss) { s.setAttribute('srcset', ss); }
            });
            document.querySelectorAll('figure[data-img-src]').forEach(function(fig){
              if (!fig.querySelector('img')) {
                var u = fig.getAttribute('data-img-src');
                if (u) {
                  var img = document.createElement('img');
                  img.setAttribute('src', u);
                  img.style.width = '100%';
                  img.style.height = 'auto';
                  fig.insertBefore(img, fig.firstChild);
                }
              }
            });
          }
          window.addEventListener('load', promoteLazy);
          promoteLazy();
        })();
        """
        let userScript = WKUserScript(source: lazyImagesJS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(userScript)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = backgroundColor
        webView.scrollView.backgroundColor = backgroundColor

        // Scroll apenas vertical
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.bounces = true
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.contentInsetAdjustmentBehavior = .always

        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        // Gera uma assinatura do conteúdo para evitar reloads desnecessários
        let signature = contentSignature(
            for: htmlContent,
            fontSize: fontSize,
            textColor: textColor,
            maxImages: maxImages,
            title: title
        )

        guard signature != context.coordinator.lastSignature else { return }
        context.coordinator.lastSignature = signature
        context.coordinator.didRunAdjustScript = false

        let styledHTML = createStyledHTML(from: htmlContent, maxImages: maxImages)
        webView.loadHTMLString(styledHTML, baseURL: baseURL)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewComponent
        var lastSignature: Int = 0
        var didRunAdjustScript = false

        init(_ parent: WebViewComponent) {
            self.parent = parent
        }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            // Links clicados abrem no Safari; o conteúdo inicial é carregado normalmente.
            if navigationAction.navigationType == .linkActivated,
               let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Ajusta layout para não estourar a largura da viewport (apenas uma vez por load).
            guard !didRunAdjustScript else { return }
            didRunAdjustScript = true

            let js = """
            (function() {
                var meta = document.querySelector('meta[name=viewport]');
                if (!meta) {
                    meta = document.createElement('meta');
                    meta.name = 'viewport';
                    document.head.appendChild(meta);
                }
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

                var images = document.querySelectorAll('img');
                images.forEach(function(img) {
                    img.style.maxWidth = '100%';
                    img.style.width = '100%';
                    img.style.height = 'auto';
                    img.style.objectFit = 'contain';
                });

                var tables = document.querySelectorAll('table');
                tables.forEach(function(table) {
                    table.style.maxWidth = '100%';
                });
            })();
            """

            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    // MARK: - HTML + CSS

    private func createStyledHTML(from raw: String, maxImages: Int) -> String {
        // Pré-processa: remove scripts/iframes, promove imagens lazy e força https
        let sanitized = sanitizeHTML(raw, maxImages: maxImages)

        // Cabeçalho com o título centralizado (se houver)
        let headerHTML: String
        if let title, !title.isEmpty {
            headerHTML = """
            <h1 class="page-title">\(escapeHTML(title))</h1>
            """
        } else {
            headerHTML = ""
        }

        let css = """
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                -webkit-text-size-adjust: 100%;
            }

            html { width: 100%; overflow-x: hidden; }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                font-size: \(fontSize)px;
                color: \(textColor);
                background-color: transparent;
                line-height: 1.6;
                padding: 16px;
                word-wrap: break-word;
                overflow-wrap: break-word;
                word-break: normal;
                -webkit-hyphens: none;
                hyphens: none;
                max-width: 100%;
                width: 100%;
                overflow-x: hidden;
            }

            .content-wrapper { max-width: 100%; width: 100%; overflow-x: hidden; }

            .page-title {
                text-align: center;
                margin-bottom: 24px;
                color: \(textColor);
                font-size: \(fontSize + 12)px;
                font-weight: 900;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }

            h1, h2, h3, h4, h5, h6 {
                color: #FF0000;
                margin-top: 16px;
                margin-bottom: 12px;
                font-weight: 800;
                max-width: 100%;
                clear: both;
            }

            p { margin-bottom: 12px; }

            a { color: #FF0000; text-decoration: underline; display: inline; }

            ul, ol { margin-left: 20px; margin-bottom: 12px; max-width: calc(100% - 20px); }
            li { margin-bottom: 6px; }

            /* TODAS as imagens ocupam a largura do conteúdo */
            img {
                display: block;
                width: 100% !important;
                max-width: 100% !important;
                height: auto !important;
                margin: 12px 0;
                object-fit: contain;
            }

            table {
                max-width: 100%;
                width: 100%;
                overflow-x: auto;
                display: block;
                border-collapse: collapse;
                margin: 12px 0;
            }

            td, th { padding: 8px; border: 1px solid #444; }

            blockquote {
                border-left: 3px solid #FF0000;
                padding-left: 16px;
                margin: 16px 0;
                color: #999;
                max-width: calc(100% - 19px);
            }

            /* Figuras sempre em bloco, largura total, sem float */
            figure {
                margin: 16px 0;
                text-align: center;
                max-width: 100%;
                width: 100% !important;
                float: none !important;
            }

            /* Mantém um pequeno destaque para figuras logo após títulos, mas ainda full width */
            h1 + figure, h2 + figure, h3 + figure {
                margin-top: 16px;
                margin-bottom: 20px;
            }

            figure[data-align], figure[data-align="right"], figure[data-align="Right"],
            figure[data-align="left"], figure[data-align="Left"] {
                float: none !important;
                margin: 16px 0;
                max-width: 100%;
                width: 100% !important;
            }

            figure img {
                width: 100% !important;
                height: auto !important;
                display: block;
            }

            figcaption {
                font-size: \(fontSize - 2)px;
                color: #999;
                margin-top: 8px;
            }

            strong, b { font-weight: 700; color: \(textColor); }
            em, i { font-style: italic; }

            code {
                font-family: 'SF Mono', Monaco, 'Courier New', monospace;
                background-color: #1a1a1a;
                padding: 2px 4px;
                border-radius: 3px;
                font-size: \(fontSize - 2)px;
            }

            pre {
                background-color: #1a1a1a;
                padding: 12px;
                border-radius: 6px;
                overflow-x: auto;
                margin: 12px 0;
                max-width: 100%;
            }

            pre code { background-color: transparent; padding: 0; }

            script, iframe { display: none !important; }

            *:not(pre) { max-width: 100%; }
        </style>
        """

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport"
                  content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
            \(css)
        </head>
        <body>
            <div class="content-wrapper">
                \(headerHTML)
                \(sanitized)
            </div>
        </body>
        </html>
        """
    }

    // MARK: - Sanitização simples de HTML

    private func sanitizeHTML(_ raw: String, maxImages: Int) -> String {
        // 1) remove <script> e <iframe>
        var cleaned = raw
        let patternsToRemove = [
            "<script[^>]*>[\\s\\S]*?</script>",
            "<iframe[^>]*>[\\s\\S]*?</iframe>"
        ]
        for pattern in patternsToRemove {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(location: 0, length: (cleaned as NSString).length)
                cleaned = regex.stringByReplacingMatches(in: cleaned, options: [], range: range, withTemplate: "")
            }
        }

        // 2) promover lazy: data-src/srcset -> src/srcset
        let replacements: [(String, String)] = [
            ("\\sdata-srcset=", " srcset="),
            ("\\sdata-src=", " src=")
        ]
        for (pattern, replacement) in replacements {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(location: 0, length: (cleaned as NSString).length)
                cleaned = regex.stringByReplacingMatches(in: cleaned, options: [], range: range, withTemplate: replacement)
            }
        }

        // 3) figuras com data-img-src sem <img> interno -> insere <img src="…">
        if let figureRegex = try? NSRegularExpression(pattern: "<figure([^>]*)data-img-src=\"([^\"]+)\"([^>]*)>([\\s\\S]*?)</figure>", options: [.caseInsensitive]) {
            let ns = cleaned as NSString
            let matches = figureRegex.matches(in: cleaned, options: [], range: NSRange(location: 0, length: ns.length))
            var output = cleaned
            for m in matches.reversed() {
                let fullRange = m.range(at: 0)
                let before = (output as NSString)
                let fragment = before.substring(with: fullRange)
                if fragment.range(of: "<img", options: .caseInsensitive) == nil,
                   m.numberOfRanges >= 3 {
                    let src = (before.substring(with: m.range(at: 2)) as String)
                    if let firstGT = fragment.firstIndex(of: ">") {
                        let prefix = fragment[..<firstGT]
                        let suffix = fragment[firstGT...]
                        let injected = "\(prefix)><img src=\"\(src)\" style=\"width:100%;height:auto;display:block;\">\(suffix.dropFirst())"
                        output = before.replacingCharacters(in: fullRange, with: injected)
                    }
                }
                cleaned = output
            }
        }

        // 4) força https
        if let httpRegex = try? NSRegularExpression(pattern: "http://", options: []) {
            let range = NSRange(location: 0, length: (cleaned as NSString).length)
            cleaned = httpRegex.stringByReplacingMatches(in: cleaned, options: [], range: range, withTemplate: "https://")
        }

        // 5) limita a quantidade de <img>, se necessário
        if maxImages < Int.max,
           let regex = try? NSRegularExpression(pattern: "<img\\b[^>]*>", options: [.caseInsensitive]) {
            let ns = cleaned as NSString
            let matches = regex.matches(in: cleaned, options: [], range: NSRange(location: 0, length: ns.length))
            if matches.count > maxImages {
                let toRemove = matches.dropFirst(maxImages)
                var mutable = ns
                for match in toRemove.reversed() {
                    mutable = mutable.replacingCharacters(in: match.range, with: "") as NSString
                }
                cleaned = String(mutable)
            }
        }

        return cleaned
    }

    private func escapeHTML(_ string: String) -> String {
        var result = string
        result = result.replacingOccurrences(of: "&", with: "&amp;")
        result = result.replacingOccurrences(of: "<", with: "&lt;")
        result = result.replacingOccurrences(of: ">", with: "&gt;")
        result = result.replacingOccurrences(of: "\"", with: "&quot;")
        result = result.replacingOccurrences(of: "'", with: "&#39;")
        return result
    }

    // MARK: - Assinatura de conteúdo

    private func contentSignature(
        for content: String,
        fontSize: Int,
        textColor: String,
        maxImages: Int,
        title: String?
    ) -> Int {
        var hasher = Hasher()
        hasher.combine(content)
        hasher.combine(fontSize)
        hasher.combine(textColor)
        hasher.combine(maxImages)
        hasher.combine(title ?? "")
        return hasher.finalize()
    }
}
