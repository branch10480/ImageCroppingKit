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
    var dummyImageString = ""
//    dummyImageString = "https://www.kodo.or.jp/cms/wp-content/uploads/2021/08/genshin-inazuma.jpg"
    dummyImageString = "https://blog.knjcode.com/wp-content/uploads/2014/02/down.jpg"
//    dummyImageString = "https://blog.knjcode.com/wp-content/uploads/2014/02/left.jpg"
//    dummyImageString = "https://blog.knjcode.com/wp-content/uploads/2014/02/right.jpg"
    DispatchQueue.global().async { [weak self] in
      if let url = URL(string: dummyImageString),
         let data = try? Data(contentsOf: url),
         let image = UIImage(data: data)
      {
        DispatchQueue.main.async {
          self?.showCroppingView(image: image)
        }
      }
    }
  }

  private func showCroppingView(image: UIImage) {
    let vc = ImageCropping.create()
    vc.configure(image: image, maskingAspectRatio: 24.0 / 9) { [weak self] type in
      switch type {
      case .crop(let image):
        self?.imageView.image = image
      case .cancel: ()
      }
    }
    present(vc, animated: true)
  }
}

