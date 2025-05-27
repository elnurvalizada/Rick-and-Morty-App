//
//  EmptyCollectionViewCell.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 19.05.25.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
  
  
  let centerView: UIView = {
    let cv = UIView()
    cv.backgroundColor = .purple.withAlphaComponent(0.7)
    cv.layer.cornerRadius = 12
    return cv
  }()
  
  let titleLabel : UILabel = {
    let lbl = UILabel()
    lbl.text = "No Data Found"
    lbl.textColor = .white
    lbl.font = .systemFont(ofSize: 24, weight: .bold)
    return lbl
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(centerView)
    
    centerView.addSubview(titleLabel)
    
    centerView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.width.equalTo(200)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
