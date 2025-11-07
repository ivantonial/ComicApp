//
//  CharacterDetailWebView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 06/11/25.
//

import SwiftUI
import WebKit

public struct CharacterDetailWebView: UIViewRepresentable {
    let htmlContent: String
    @Binding var isPresented: Bool

    public init(htmlContent: String, isPresented: Binding<Bool>) {
        self.htmlContent = htmlContent
        self._isPresented = isPresented
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black

        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        let styledHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    color: #E0E0E0;
                    background-color: #000000;
                    padding: 20px;
                    margin: 0;
                    word-wrap: break-word;
                    overflow-wrap: break-word;
                }
                
                h1, h2, h3, h4, h5, h6 {
                    color: #FF0000;
                    margin-top: 20px;
                    margin-bottom: 10px;
                }
                
                p {
                    margin: 10px 0;
                }
                
                a {
                    color: #FF4444;
                    text-decoration: none;
                }
                
                img {
                    max-width: 100%;
                    height: auto;
                    display: block;
                    margin: 15px auto;
                    border-radius: 8px;
                }
                
                ul, ol {
                    padding-left: 25px;
                }
                
                li {
                    margin: 5px 0;
                }
                
                blockquote {
                    border-left: 3px solid #FF0000;
                    padding-left: 15px;
                    margin: 15px 0;
                    color: #B0B0B0;
                }
                
                figure {
                    margin: 20px 0;
                    text-align: center;
                }
                
                figcaption {
                    font-size: 14px;
                    color: #909090;
                    margin-top: 8px;
                }
                
                /* Remove elementos desnecessários da ComicVine */
                .js-lazy-load-image {
                    display: none;
                }
            </style>
        </head>
        <body>
            \(htmlContent)
        </body>
        </html>
        """

        webView.loadHTMLString(styledHTML, baseURL: nil)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CharacterDetailWebView

        init(_ parent: CharacterDetailWebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}

// MARK: - Sheet Wrapper
public struct CharacterDetailWebSheet: View {
    let htmlContent: String
    @Binding var isPresented: Bool

    public init(htmlContent: String, isPresented: Binding<Bool>) {
        self.htmlContent = htmlContent
        self._isPresented = isPresented
    }

    public var body: some View {
        NavigationView {
            CharacterDetailWebView(
                htmlContent: htmlContent,
                isPresented: $isPresented
            )
            .navigationTitle("Character Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
