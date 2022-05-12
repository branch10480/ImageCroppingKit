//
//  File.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/05/12.
//

import Foundation
import UIKit

public extension UIImage {
  func resized(maxLength: CGFloat) -> UIImage? {
    let originalSize = size
    var newSize = CGSize.zero
    let width = originalSize.width
    let height = originalSize.height

    if width > height {
      newSize.width = maxLength
      newSize.height = maxLength * height / width
    } else {
      newSize.width = maxLength * width / height
      newSize.height = maxLength
    }

    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { context in
      draw(in: .init(origin: .zero, size: newSize))
    }
  }
}
