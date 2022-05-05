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
    present(vc, animated: true)
  }
}

