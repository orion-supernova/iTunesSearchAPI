//
//  ResultTableViewCell.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

   static let identifier = "ResultTableViewCell"
    
    private let resultTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let resultDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    private let resultImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let resultPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(resultTitleLabel)
        contentView.addSubview(resultDescriptionLabel)
        contentView.addSubview(resultPriceLabel)
        contentView.addSubview(resultImageView)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var result: Result! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        resultTitleLabel.text = result.name
        resultDescriptionLabel.text = result.description
        
        if result.price == 0 {
            resultPriceLabel.text = result.formattedPrice
        } else {
            resultPriceLabel.text = "$\(result.price)"
        }
        
        self.resultImageView.image = nil
        if let url = result.artworkUrl {
            let request = URLRequest(url: url)
            let networkProcessor = NetworkProcessor(request: request)
            
            networkProcessor.downloadData(completion: { (data, response, error) in
                // WE'RE OFF THE MAIN QUEUE!!!!!!!!!
                // WE NEED TO GET BACK ON THE MAIN QUEUE
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.resultImageView.image = UIImage(data: imageData)
                        self.resultImageView.layer.cornerRadius = 10.0
                        self.resultImageView.layer.masksToBounds = true
                    }
                }
            })
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resultTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width-170,
                                      height: 40)
        resultDescriptionLabel.frame = CGRect(x: 10,
                                              y: resultTitleLabel.frame.origin.y + resultTitleLabel.frame.size.height + 10,
                                      width: contentView.frame.size.width-170,
                                      height: contentView.frame.size.height/2-20)
        resultImageView.frame = CGRect(x: contentView.frame.size.width-150,
                                      y: 5,
                                      width: 140,
                                      height: contentView.frame.size.height-10)
        resultPriceLabel.frame = CGRect(x: 10,
                                        y: contentView.frame.origin.y + contentView.frame.size.height - 20,
                                        width: 40,
                                        height: 20)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resultTitleLabel.text = nil
        resultDescriptionLabel.text = nil
        resultImageView.image = nil
        resultPriceLabel.text = nil
    }
    
    
    
}
