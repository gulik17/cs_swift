//
//  FriendPhotoList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import INSPhotoGallery

private let reuseIdentifier = "FriendPhotoCell"

class FriendPhotoList: UICollectionViewController {
    
    var photoCollection = [1,2,3,4,5,6]
    
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendPhotoCell
        return cell
    }
    
    lazy var photos: [INSPhotoViewable] = {
        return [
            INSPhoto(imageURL: URL(string: "https://inspace.io/assets/portfolio/thumb/13-3f15416ddd11d38619289335fafd498d.jpg"), thumbnailImage: UIImage(named: "thumbnailImage")!),
            INSPhoto(imageURL: URL(string: "https://inspace.io/assets/portfolio/thumb/13-3f15416ddd11d38619289335fafd498d.jpg"), thumbnailImage: UIImage(named: "thumbnailImage")!),
            INSPhoto(image: UIImage(named: "fullSizeImage")!, thumbnailImage: UIImage(named: "thumbnailImage")!),
        ]
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotoCell
        let currentPhoto = photos[indexPath.row]
        
        print(currentPhoto)
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)

        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.firstIndex(where: {$0 === photo}) {
                let indexPath = NSIndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath as IndexPath) as? FriendPhotoCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
}
