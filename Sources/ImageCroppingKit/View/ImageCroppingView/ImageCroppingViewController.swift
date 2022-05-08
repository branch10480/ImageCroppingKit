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

  typealias CloseType = ImageCropping.CloseType

  private var maskingAspectRatio: CGFloat = 1.0
  private var didClose: ((CloseType) -> ())?

  private var image: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupImage(image)
  }


  private func setup() {
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0

    maskView.maskingAspectRatio = maskingAspectRatio
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
    var verticalInset = (viewHeight - imageHeight) / 2
    let diff = imageHeight - maskView.maskingRect.height
    if diff > 0 {
      verticalInset += diff / 2
    }
    scrollView.contentInset.top = verticalInset
    scrollView.contentInset.bottom = verticalInset
    scrollView.contentOffset.y = -verticalInset + diff / 2
  }

  private func cropImage() -> UIImage? {
    guard let image = image else {
      return nil
    }

    let dummyCropAreaView = UIView()
    dummyCropAreaView.frame = maskView.maskingRect
    let cropArea = dummyCropAreaView.convert(dummyCropAreaView.bounds, to: scrollView)

    let imageScale = max(image.size.width / imageView.frame.width,
                         image.size.height / imageView.frame.height)
    var cropZone = CGRect(x: cropArea.origin.x * imageScale,
                          y: cropArea.origin.y * imageScale,
                          width: cropArea.width * imageScale,
                          height: cropArea.height * imageScale)
    cropZone = transform(rect: cropZone, by: image)

    guard let croppedCGImage = image.cgImage?.cropping(to: cropZone) else {
      return nil
    }
    let croppedImage = UIImage(cgImage: croppedCGImage,
                               scale: 0,
                               orientation: image.imageOrientation)
    return croppedImage
  }

  private func transform(rect: CGRect, by image: UIImage) -> CGRect {
    var transform: CGAffineTransform
    let imageOrientation = image.imageOrientation
    switch imageOrientation {
    case .left:
      transform = CGAffineTransform(rotationAngle: .pi / 2).translatedBy(x: 0, y: -image.size.height)
    case .right:
      transform = CGAffineTransform(rotationAngle: -.pi / 2).translatedBy(x: -image.size.width, y: 0)
    case .down:
      transform = CGAffineTransform(rotationAngle: -.pi).translatedBy(x: -image.size.width, y: -image.size.height)
    default:
      transform = .identity
    }
    return rect.applying(transform)
  }

  private func dismiss(_ type: CloseType) {
    dismiss(animated: true)
    didClose?(type)
  }

  @IBAction func didTapCloseButton(_ sender: Any) {
    dismiss(.cancel)
  }

  @IBAction func didTapDoneButton(_ sender: Any) {
    let image = cropImage()
    dismiss(.crop(image))
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
    var heightInset = max((scrollView.frame.height - imageView.frame.height) / 2, 0)
    let diff = imageView.frame.height - maskView.maskingRect.height
    if diff > 0 {
      heightInset += diff / 2
    }
    scrollView.contentInset = .init(top: heightInset,
                                    left: widthInset,
                                    bottom: heightInset,
                                    right: widthInset)
  }

}

// MARK: - ImageCroppingController

extension ImageCroppingViewController: ImageCroppingController {
  func configure(image: UIImage, maskingAspectRatio ratio: CGFloat, didClose: ((CloseType) -> ())?) {
    self.image = image
    self.maskingAspectRatio = ratio
    self.didClose = didClose
  }
}
