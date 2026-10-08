import SwiftUI
import WebKit

/// The whole app is the web app in the Web folder (index.html, images, fonts), shown full screen.
/// Library, playlists and settings live in the page's IndexedDB, which the default website data
/// store keeps across app restarts.
struct WebAppView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true                // <video playsinline> stays inside the page
        config.mediaTypesRequiringUserActionForPlayback = []   // the next video starts by itself when one ends
        config.allowsPictureInPictureMediaPlayback = false
        config.websiteDataStore = .default()                   // persistent, not the throwaway private store

        let webFolder = Self.webFolderURL()
        if let webFolder {
            config.setURLSchemeHandler(WebFolderSchemeHandler(root: webFolder), forURLScheme: "app")
        }

        let webView = WKWebView(frame: .zero, configuration: config)
        let background = UIColor(red: 14 / 255, green: 9 / 255, blue: 9 / 255, alpha: 1)   // #0E0909, the page's own
        webView.isOpaque = false
        webView.backgroundColor = background
        webView.scrollView.backgroundColor = background
        webView.scrollView.contentInsetAdjustmentBehavior = .never   // safe areas are handled by the page's CSS

        if webFolder != nil {
            // Not loadFileURL: WebKit keeps storage off for file:// pages, and the library is in IndexedDB.
            // app://localhost is a real origin, so its IndexedDB persists like a website's.
            webView.load(URLRequest(url: URL(string: "app://localhost/index.html")!))
        } else {
            webView.loadHTMLString("<p style='color:#fff;font:17px -apple-system;padding:60px 24px'>Web/index.html fehlt im App-Paket.</p>", baseURL: nil)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    /// The Web folder wherever the build put the resources: the app bundle itself, or a
    /// resource bundle inside it (Swift packages can do either).
    static func webFolderURL() -> URL? {
        var bundles = [Bundle.main] + Bundle.allBundles
        if let nested = Bundle.main.urls(forResourcesWithExtension: "bundle", subdirectory: nil) {
            bundles += nested.compactMap { Bundle(url: $0) }
        }
        for bundle in bundles {
            if let index = bundle.url(forResource: "index", withExtension: "html", subdirectory: "Web") {
                return index.deletingLastPathComponent()
            }
        }
        return nil
    }
}

/// Answers app://localhost/<path> with the file <path> from the Web folder.
final class WebFolderSchemeHandler: NSObject, WKURLSchemeHandler {
    let root: URL

    init(root: URL) {
        self.root = root
        super.init()
    }

    func webView(_ webView: WKWebView, start task: WKURLSchemeTask) {
        guard let url = task.request.url else { return }
        let file = root.appendingPathComponent(String(url.path.dropFirst()))
        guard let data = try? Data(contentsOf: file) else {
            task.didReceive(HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!)
            task.didFinish()
            return
        }
        let headers = [
            "Content-Type": Self.mimeTypes[file.pathExtension.lowercased()] ?? "application/octet-stream",
            "Content-Length": String(data.count)
        ]
        task.didReceive(HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers)!)
        task.didReceive(data)
        task.didFinish()
    }

    // every request is answered at once in start, so there's nothing to cancel
    func webView(_ webView: WKWebView, stop task: WKURLSchemeTask) {}

    static let mimeTypes = [
        "html": "text/html; charset=utf-8",
        "css": "text/css; charset=utf-8",
        "png": "image/png",
        "woff2": "font/woff2",
        "txt": "text/plain; charset=utf-8"
    ]
}
