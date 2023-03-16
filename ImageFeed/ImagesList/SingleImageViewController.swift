//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 07.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private var imageView: UIImageView!
    
    @IBAction private func DidTapSharingButton(_ sender: Any)  {
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activityViewController.view.backgroundColor = .ypBlack
        activityViewController.overrideUserInterfaceStyle = .ypBlack
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction private func DidTapBackButton(_ sender: UIButton) {dismiss(animated: true,completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    

    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = max(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.maximumZoomScale = scale > scrollView.maximumZoomScale ? scale : scrollView.maximumZoomScale // для растягивания на весь экран
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
