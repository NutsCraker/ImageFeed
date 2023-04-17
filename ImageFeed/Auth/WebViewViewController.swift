//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 22.02.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [], changeHandler: { [weak self] _, _ in
            guard let self = self else { return }
            self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction private func didTapeBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    

    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { records in
            records.forEach({ record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            })
        })
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func  webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}


