//
//  HomeActivityCell.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import UIKit
import Nuke

class HomeActivityCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
}

extension HomeActivityCell {
    func configure(withRepoItem item: HomeActivityResultItem) {
        selectionStyle = .none
        starButton.cornerRadius = 15
        userImage.cornerRadius = userImage.layer.frame.height/2
        userImage.borderColor = .lightGray
        userImage.borderWidth = 2
        userImage.clipsToBounds = true
        if let url = item.imageUrl {
            Nuke.loadImage(with: URL(string: url)!, into: userImage)
        }
        backView.cornerRadius = 15
        backView.clipsToBounds = true
        repoName.text = item.name
        starsLabel.text = item.stars.description
        userName.text = item.author
    }
}


extension HomeActivityCell: CellConfiguratorProtocol {
    static var cellClass: AnyClass {
        return HomeActivityCell.self
    }

    static var cellNib: UINib {
        return UINib(nibName: HomeActivityCell.className, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: cellClass)
    }
}
