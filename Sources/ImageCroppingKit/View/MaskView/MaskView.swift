//
//  MaskView.swift
//  
//
//  Created by Toshiharu Imaeda on 2022/05/05.
//

import UIKit

class MaskView: UIView {
  var maskingAspectRatio: CGFloat = 1

  private var maskedLayer: CALayer?

  private func createLayer(innerOf parentLayer: CALayer) -> CALayer {
    let targetLayer = CALayer()
    targetLayer.bounds = parentLayer.bounds
    // これを指定しないと表示位置がおかしくなる
    targetLayer.position = parentLayer.position
    targetLayer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor

    let maskLayer = CAShapeLayer()
    maskLayer.bounds = targetLayer.bounds

    let width = targetLayer.bounds.width
    let height = width / maskingAspectRatio
    let squareRect = CGRect(x: 0,
                            y: (targetLayer.bounds.height - height) / 2,
                            width: width,
                            height: height)
    let path = UIBezierPath(rect: squareRect)
    path.append(UIBezierPath(rect: maskLayer.bounds))
    maskLayer.fillColor = UIColor.black.cgColor
    maskLayer.path = path.cgPath
    maskLayer.position = .init(x: targetLayer.bounds.width / 2, y: targetLayer.bounds.height / 2)
    maskLayer.fillRule = .evenOdd

    targetLayer.mask = maskLayer

    return targetLayer
  }

  override func layoutSublayers(of layer: CALayer) {
    if let layer = maskedLayer {
      layer.removeFromSuperlayer()
    }
    let newLayer = createLayer(innerOf: layer)
    maskedLayer = newLayer
    layer.addSublayer(newLayer)
  }

}
