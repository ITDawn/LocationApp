//
//  PinViewCell.swift
//  Location
//
//  Created by Dany on 31.10.2021.
//

import UIKit

class PinViewCell: UITableViewCell {
    
    var pinSet: Pin? {
         
         didSet {
            titleLabel.text = pinSet?.name
            descriptionLabel.text = pinSet?.caption
            imageSet.image = UIImage(named: "logo3")
         }
     }
    let imageSet:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        
        return label
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupViews()
    }
    
}
extension PinViewCell {
    private func setupViews(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(imageSet)
        
        let constraints = [
            imageSet.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageSet.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageSet.heightAnchor.constraint(equalToConstant: 35),
            imageSet.widthAnchor.constraint(equalToConstant: 35),
           
            
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
