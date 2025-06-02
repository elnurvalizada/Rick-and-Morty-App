//
//  CharacterCollectionViewCell.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit

class CharacterCollectionViewCell : UICollectionViewCell {
  let centerStack: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.spacing = 6
    sv.alignment = .center
    return sv
  }()
  
  let mainImage: ImageView = {
    let img = ImageView()
    img.layer.cornerRadius = 24
    img.layer.masksToBounds = true
    return img
  }()
  
  let genderIcon: UIImageView = {
    let img = UIImageView()
    return img
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.textColor = .white
    return label
  }()
  
  let speciesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .white
    return label
  }()
  
  private var imageRequest: URLRequest? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(centerStack)
    contentView.addSubview(genderIcon)
    
    centerStack.addArrangedSubview(mainImage)
    centerStack.addArrangedSubview(nameLabel)
    centerStack.setCustomSpacing(2, after: nameLabel)
    centerStack.addArrangedSubview(speciesLabel)
    
    centerStack.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalTo(contentView).inset(6)
    }
    genderIcon.snp.makeConstraints { make in
      make.height.width.equalTo(32)
      make.top.equalTo(contentView).inset(12)
      make.trailing.equalTo(contentView.snp.trailing).inset(12)
    }
    mainImage.snp.makeConstraints { make in
      make.height.width.equalTo(160)
    }
    
  }
  
  func config(character: CharacterResponse.Character) {
    mainImage.loadImage(urlString: character.image)
    nameLabel.text = character.name
    speciesLabel.text = character.species
    
    genderIcon.image = character.genderIcon
    genderIcon.tintColor = character.genderBackgroundColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    mainImage.image = nil
    guard let imageRequest else { return }
    mainImage.cancel(request: imageRequest)
  }
}
