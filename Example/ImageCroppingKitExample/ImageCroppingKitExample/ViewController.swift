//
//  ViewController.swift
//  ImageCroppingKitExample
//
//  Created by Toshiharu Imaeda on 2022/05/05.
//

import UIKit
import ImageCroppingKit

class ViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var button: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func didTapButton(_ sender: Any) {
    let vc = ImageCropping.create()
    vc.configure(maskingAspectRatio: 24.0 / 9) { [weak self] type in
      switch type {
      case .crop(let image):
        self?.imageView.image = image
      case .cancel: ()
      }
    }
    present(vc, animated: true)
  }
}

