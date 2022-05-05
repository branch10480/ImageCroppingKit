//
//  ImageCroppingViewController.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/05/05.
//

import UIKit

class ImageCroppingViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setup() {
  }

  @IBAction func didTapCloseButton(_ sender: Any) {
    dismiss(animated: true)
  }

}

// MARK: - ImageCroppingController

extension ImageCroppingViewController: ImageCroppingController {
  func configure() {
  }
}
