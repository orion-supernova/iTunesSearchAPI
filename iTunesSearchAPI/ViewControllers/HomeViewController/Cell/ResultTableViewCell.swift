//
//  ResultTableViewCell.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import UIKit
import Kingfisher

class ResultTableViewCell: UITableViewCell {

   static let identifier = "ResultTableViewCell"
    
    private let resultImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(resultImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            self.resultImageView.kf.setImage(with: url)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resultImageView.frame = CGRect(x: (contentView.frame.size.width-140)/2,
                                      y: 5,
                                      width: 140,
                                      height: contentView.frame.size.height-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.image = nil
    }
    
    
    
}
