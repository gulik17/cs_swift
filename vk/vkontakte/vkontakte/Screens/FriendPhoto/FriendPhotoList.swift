//
//  FriendPhotoList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import INSPhotoGallery
import Kingfisher

private let reuseIdentifier = "FriendPhotoCell"

class FriendPhotoList: UICollectionViewController {
    
    var photoCollection = [Photo]()
    
    var user: String?
    var userId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = VKApi()
        api.getFriendPhotoList(token: Session.shared.token, ownerId: userId) { (data: Swift.Result<[Photo], Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.photoCollection = resData
                self.collectionView.reloadData()
                print(self.photoCollection)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendPhotoCell
        let url = URL(string: photoCollection[indexPath.row].sizes.first(where: { $0.type == .m })!.url)
        cell.photo.kf.indicatorType = .activity
        cell.photo.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        return cell
    }
    
    lazy var photos: [INSPhotoViewable] = {
        var photoArray = [CustomPhotoModel]()
        photoCollection.forEach { (item) in
            if let imageURL = item.sizes.first(where: { $0.type == .y }) {
                if let thumbnailImageURL = item.sizes.first(where: { $0.type == .x }) {
                    photoArray.append(
                        CustomPhotoModel(
                            imageURL: URL(string: imageURL.url),
                            thumbnailImageURL: URL(string: thumbnailImageURL.url)
                        )
                    )
                }
            }
        }
        return photoArray
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendPhotoCell
        let currentPhoto = photos[indexPath.row]

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
