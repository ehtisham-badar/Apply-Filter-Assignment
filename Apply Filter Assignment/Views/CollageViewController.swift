//
//  CollageViewController.swift
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 13/08/2023.
//

import UIKit

class CollageViewController: UIViewController {

    @IBOutlet weak var collageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let collageView = DiagonalCollageView(frame: self.collageView.bounds)
        collageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collageView.addSubview(collageView)
    }
}

class DiagonalCollageView: UIView {
    var sourceImageView1: UIImageView!
    var sourceImageView2: UIImageView!
    var sourceImageView3: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImages()
    }

    private func setupImages() {
        sourceImageView1 = UIImageView(image: UIImage(named: "sourceimage"))
        sourceImageView2 = UIImageView(image: UIImage(named: "sourceimage2"))
        sourceImageView3 = UIImageView(image: UIImage(named: "sourceimage3"))

        sourceImageView1.frame = CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height)
        sourceImageView2.frame = CGRect(x: bounds.width / 2, y: 0, width: bounds.width / 2, height: bounds.height / 2)
        sourceImageView3.frame = CGRect(x: bounds.width / 2, y: bounds.height / 2, width: bounds.width / 2, height: bounds.height / 2)

        sourceImageView1.isUserInteractionEnabled = true
        sourceImageView2.isUserInteractionEnabled = true
        sourceImageView3.isUserInteractionEnabled = true

        addSubview(sourceImageView1)
        addSubview(sourceImageView2)
        addSubview(sourceImageView3)

        let panGesture1 = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let panGesture3 = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))

        sourceImageView1.addGestureRecognizer(panGesture1)
        sourceImageView2.addGestureRecognizer(panGesture2)
        sourceImageView3.addGestureRecognizer(panGesture3)
    }

    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard let imageView = gestureRecognizer.view else { return }

            let translation = gestureRecognizer.translation(in: self)
            
            let newX = imageView.center.x + translation.x
            let newY = imageView.center.y + translation.y
            
            // Constrain to stay within the boundaries of the box
            let minX = imageView.bounds.width / 2
            let maxX = bounds.width - imageView.bounds.width / 2
            let minY = imageView.bounds.height / 2
            let maxY = bounds.height - imageView.bounds.height / 2
            
            imageView.center.x = max(minX, min(maxX, newX))
            imageView.center.y = max(minY, min(maxY, newY))
            
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let diagonalLength = sqrt(rect.width * rect.width + rect.height * rect.height)
        let diagonalAngle: CGFloat = 30.0
        let diagonalAngleRadians = diagonalAngle * .pi / 180.0
        let sourceImage2StartPoint = CGPoint(x: center.x, y: 0)
        let sourceImage2EndPoint = CGPoint(x: center.x + diagonalLength / 4 * cos(diagonalAngleRadians),
                                           y: rect.height / 2)
        let sourceImage3StartPoint = CGPoint(x: center.x, y: rect.height / 2)
        let sourceImage3EndPoint = CGPoint(x: center.x + diagonalLength / 4 * cos(diagonalAngleRadians),
                                           y: rect.height)
        let sourceImage2Path = UIBezierPath()
        sourceImage2Path.move(to: sourceImage2StartPoint)
        sourceImage2Path.addLine(to: sourceImage2EndPoint)
        let sourceImage3Path = UIBezierPath()
        sourceImage3Path.move(to: sourceImage3StartPoint)
        sourceImage3Path.addLine(to: sourceImage3EndPoint)
        UIColor.black.setStroke()
        sourceImage2Path.stroke()
        sourceImage3Path.stroke()
        let leftImageRect = CGRect(x: 0, y: 0, width: center.x, height: rect.height)
        let rightTopImageRect = CGRect(x: center.x, y: 0, width: center.x, height: rect.height / 2)
        let rightBottomImageRect = CGRect(x: center.x, y: rect.height / 2, width: center.x, height: rect.height / 2)
        if let sourceImage1 = UIImage(named: "sourceimage"),
           let sourceImage2 = UIImage(named: "sourceimage2"),
           let sourceImage3 = UIImage(named: "sourceimage3") {
            sourceImage1.draw(in: leftImageRect)
            sourceImage2.draw(in: rightTopImageRect)
            if let cgImage = sourceImage3.cgImage {
                context.saveGState()
                context.translateBy(x: rightBottomImageRect.midX, y: rightBottomImageRect.midY)
                context.scaleBy(x: 1, y: -1) // Flip vertically
                context.translateBy(x: -rightBottomImageRect.midX, y: -rightBottomImageRect.midY)
                context.draw(cgImage, in: rightBottomImageRect)
                context.restoreGState()
            }
        }
    }
}
