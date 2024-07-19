//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 12.07.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded else { return }
            showImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        showImage()
    }
    
    func showImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.rescaleAndCenterImageInScrollView(image: image.image)
            case .failure:
                self.showError()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Ошибка при загрузке картинки. Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "Нет", style: .default ) { _ in
            alert.dismiss(animated: true)
        }
        
        let retryAction = UIAlertAction(title: "Попробовать еше раз?", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showImage()
        }
        
        alert.addAction(dismissAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
       }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        rescaleAndCenterImageInScrollView(image: imageView.image!)
    }
}
