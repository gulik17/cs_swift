//
//  FriendPhotoCell.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class FriendPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!

    @IBAction func likeBtn(_ sender: LikeButton) {
        sender.like()
    }
}
