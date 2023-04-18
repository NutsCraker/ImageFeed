//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 05.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            guard isViewLoaded else { return }
            setImage(url: imageURL)
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 1.25
        scrollView.minimumZoomScale = 0.1
        scrollView.delegate = self
        setImage(url: imageURL)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        activityViewController.view.backgroundColor = .ypBlack
               activityViewController.overrideUserInterfaceStyle = .dark
        present(activityViewController, animated: true)
    }
    
    func setImage(url: URL?) {
        guard let url = url else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let resultImage):
                self.rescaleAndCenterImageInScrollView(image: resultImage.image)
            case .failure(_):
                self.showError()
            }
        }
    }
    
    private  func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension SingleImageViewController {
    private func showError() {
        let alert = UIAlertController(title: nil, message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let dissmissAction = UIAlertAction(title: "Не надо", style: .default) {_ in
            alert.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.setImage(url: self.imageURL)
        }
        alert.addAction(dissmissAction)
        alert.addAction(repeatAction)
        present(alert, animated: true)
    }
}
