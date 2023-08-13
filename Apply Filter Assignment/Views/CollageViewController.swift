//
//  CollageViewController.swift
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 13/08/2023.
//

import UIKit
import PhotosUI

class CollageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collageView: UIView!
    var imageViews: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollageView()
    }
    
    func setupCollageView() {
        let collageView = DiagonalCollageView(frame: self.collageView.bounds)
        collageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collageView.addSubview(collageView)
        
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: collageView.bounds.width / 2, height: collageView.bounds.height))
        leftImageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        leftImageView.addGestureRecognizer(tapGestureRecognizer1)
        leftImageView.isUserInteractionEnabled = true
        collageView.addSubview(leftImageView)
        imageViews.append(leftImageView)
        
        let rightTopImageView = UIImageView(frame: CGRect(x: collageView.bounds.width / 2, y: 0, width: collageView.bounds.width / 2, height: collageView.bounds.height / 2))
        rightTopImageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        rightTopImageView.addGestureRecognizer(tapGestureRecognizer2)
        rightTopImageView.isUserInteractionEnabled = true
        collageView.addSubview(rightTopImageView)
        imageViews.append(rightTopImageView)
        
        let rightBottomImageView = UIImageView(frame: CGRect(x: collageView.bounds.width / 2, y: collageView.bounds.height / 2, width: collageView.bounds.width / 2, height: collageView.bounds.height / 2))
        rightBottomImageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        rightBottomImageView.addGestureRecognizer(tapGestureRecognizer3)
        rightBottomImageView.isUserInteractionEnabled = true
        collageView.addSubview(rightBottomImageView)
        imageViews.append(rightBottomImageView)
    }
    
    

    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let tappedImageView = gestureRecognizer.view as? UIImageView {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary // Specify the source as the photo library
            tappedImageView.tag = imageViews.firstIndex(of: tappedImageView) ?? 0 // Set a tag to identify the tapped image view
            print("Tapped ImageView Tag: \(tappedImageView.tag)")
            present(imagePicker, animated: true, completion: nil)
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage,
              let tappedImageViewTag = picker.view?.tag,
              let tappedImageView = imageViews[safe: tappedImageViewTag] else {
            return
        }
        
        tappedImageView.image = selectedImage
    }




}

class DiagonalCollageView: UIView {
    
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
                context.scaleBy(x: 1, y: -1)
                context.translateBy(x: -rightBottomImageRect.midX, y: -rightBottomImageRect.midY)
                context.draw(cgImage, in: rightBottomImageRect)
                context.restoreGState()
            }
        }
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
