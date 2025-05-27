//
//  filteredCollectionViewCell.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit


class FilteredCollectionViewCell : UICollectionViewCell {
  
  let mainView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 8
    return view
  }()
  
  let centerStack : UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .fillProportionally
    sv.spacing = 10
    return sv
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .systemPurple
    return label
  }()
  
  let rightIcon : UIImageView = {
    let img = UIImageView()
    img.image = UIImage(systemName: "chevron.right")
    img.tintColor = .systemPurple
    return img
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(mainView)
    mainView.addSubview(centerStack)
    
    centerStack.addArrangedSubview(titleLabel)
    centerStack.addArrangedSubview(rightIcon)
    
    mainView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    centerStack.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(6)
      make.leading.trailing.equalToSuperview().inset(12)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func config(title : String, selectedValue: String?) {
    if let selectedValue, !selectedValue.isEmpty {
      titleLabel.text = "\(title): \(selectedValue)"
    } else {
      titleLabel.text = title
    }
  }
}
