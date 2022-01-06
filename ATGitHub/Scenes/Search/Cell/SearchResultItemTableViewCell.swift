//
//  SearchResultItemTableViewCell.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit
import Nuke

class SearchResultItemTableViewCell: UITableViewCell {
    @IBOutlet private(set) var backView: UIView!
    @IBOutlet private(set) var authorLabel: UILabel!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var starLabel: UILabel!
    @IBOutlet private(set) var itemImageView: UIImageView!
    @IBOutlet private(set) var setStarView: UIButton!
    
    var isStarred = false {
        didSet {
            if let author = authorLabel.text, let title = titleLabel.text {
                if isStarred {
                    setStarView.backgroundColor = .systemBlue
                    GitHubAPIService().starRepoRequest(bool: true, userName: author , repoName: title)
                } else {
                    setStarView.backgroundColor = .tertiaryLabel
                    GitHubAPIService().starRepoRequest(bool: false, userName: author , repoName: title)
                }
            }
        }
    }
    
    @IBAction func setStar(_ sender: UIButton) {
        isStarred = !isStarred
    }
}

extension SearchResultItemTableViewCell {
    func configure(withRepoItem item: SearchResultItem, selectedItems: [SearchResultItem]) {
        selectionStyle = .none
        setStarView.cornerRadius = 15
        itemImageView.cornerRadius = itemImageView.layer.frame.height/2
        itemImageView.borderColor = .lightGray
        itemImageView.borderWidth = 2
        itemImageView.clipsToBounds = true
        if let url = item.imageUrl {
            Nuke.loadImage(with: URL(string: url)!, into: itemImageView)
        }
        backView.cornerRadius = 15
        backView.clipsToBounds = true
        titleLabel.text = item.name
        starLabel.text = item.stars.description
        authorLabel.text = item.author
        if selectedItems.contains(where: { $0.id == item.id}) {
            backView.borderWidth = 2
            backView.borderColor = .systemBlue
        } else {
            backView.borderWidth = 0
        }
    }
}


extension SearchResultItemTableViewCell: CellConfiguratorProtocol {
    static var cellClass: AnyClass {
        return SearchResultItemTableViewCell.self
    }

    static var cellNib: UINib {
        return UINib(nibName: SearchResultItemTableViewCell.className, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: cellClass)
    }
}
