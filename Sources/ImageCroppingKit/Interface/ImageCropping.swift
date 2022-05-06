//
//  File.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/05/05.
//

import Foundation
import UIKit

public struct ImageCropping {
  public static func create() -> ImageCroppingController {
    let name = String(describing: ImageCroppingViewController.self)
    let sb = UIStoryboard(name: name, bundle: Bundle.module)
    let vc = sb.instantiateInitialViewController() as! ImageCroppingController
    vc.modalTransitionStyle = .coverVertical
    vc.modalPresentationStyle = .overFullScreen
    return vc
  }

  public enum CloseType {
    case crop(UIImage?)
    case cancel
  }

}

public protocol ImageCroppingController: UIViewController {
  /// Configure params.
  /// - Parameter maskingAspectRatio: Width / Height
  func configure(maskingAspectRatio ratio: CGFloat, didClose: ((ImageCropping.CloseType) -> ())?)
}
