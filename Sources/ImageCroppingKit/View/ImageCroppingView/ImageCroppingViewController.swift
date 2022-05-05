//
//  ImageCroppingViewController.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/05/05.
//

import UIKit

class ImageCroppingViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var maskView: MaskView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

  private var maskingAspectRatio: CGFloat = 1.0

  private var image: UIImage? {
    didSet {
      setupImage(image)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    maskView.maskingAspectRatio = maskingAspectRatio
    setupDummyImage()
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0
  }

  private func setupImage(_ image: UIImage?) {
    guard let width = image?.size.width, let height = image?.size.height else {
      imageView.image = nil
      return
    }
    imageView.image = image
    let viewHeight = UIScreen.main.bounds.height
    let viewWidth = UIScreen.main.bounds.width
    let imageHeight = viewWidth * height / width
    imageHeightConstraint.constant = imageHeight
    let verticalInset = (viewHeight - imageHeight) / 2
    scrollView.contentInset.top = verticalInset
    scrollView.contentInset.bottom = verticalInset
  }

  private func setupDummyImage() {
    #if targetEnvironment(simulator)
    let dummyImageString = "https://www.kodo.or.jp/cms/wp-content/uploads/2021/08/genshin-inazuma.jpg"
    DispatchQueue.global().async { [weak self] in
      if let url = URL(string: dummyImageString),
         let data = try? Data(contentsOf: url) {
        DispatchQueue.main.async {
          self?.image = UIImage(data: data)
        }
      }
    }
    #endif
  }

  @IBAction func didTapCloseButton(_ sender: Any) {
    dismiss(animated: true)
  }

}

extension ImageCroppingViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateContentInset()
  }

  private func updateContentInset() {
    let widthInset = max((scrollView.frame.width - imageView.frame.width) / 2, 0)
    let heightInset = max((scrollView.frame.height - imageView.frame.height) / 2, 0)
    scrollView.contentInset = .init(top: heightInset,
                                    left: widthInset,
                                    bottom: heightInset,
                                    right: widthInset)
  }

}

// MARK: - ImageCroppingController

extension ImageCroppingViewController: ImageCroppingController {
  func configure(maskingAspectRatio ratio: CGFloat) {
    self.maskingAspectRatio = ratio
  }
}
