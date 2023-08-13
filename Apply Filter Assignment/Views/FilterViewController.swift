//
//  FilterViewController.swift
//  Apply Filter Assignment
//
//  Created by Ehtisham Badar on 12/08/2023.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var imageView: UIImageView!
    
    var viewModel = FilterViewModel()
    var originalImage: UIImage? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let imageToSave = imageView?.image {
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the error
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved successfully.")
        }
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.availableFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let filter = viewModel.availableFilters[indexPath.item]
        let thumbnailImage = viewModel.thumbnailImage(for: filter)
        cell.filterName.text = viewModel.availableFilters[indexPath.item].rawValue
        cell.imageView.image = thumbnailImage
        cell.imageView.layer.cornerRadius = 20.0
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = viewModel.filteredImagea[indexPath.item]
    }
}

class FilterCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var filterName: UILabel!
}
