//
//  DetailViewController.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit
import Kingfisher

final class DetailViewController : UIViewController {
  
  var isSaved : Bool = false
  
  let topStack : UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .equalSpacing
    sv.alignment = .fill
    return sv
  }()
  let backButton : UIButton = {
    let btn = UIButton(type: .system)
    btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    btn.tintColor = .white
    return btn
  }()
  let saveButton : UIButton = {
    let btn = UIButton(type: .system)
    btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
    btn.tintColor = .white
    return btn
  }()
  
  let centerStack : UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.distribution = .fill
    sv.alignment = .center
    return sv
  }()
  
  let titleLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 34, weight: .bold)
    lbl.textColor = .white
    return lbl
  }()
  let centerImg: UIImageView = {
    let img = UIImageView()
    img.clipsToBounds = true
    img.layer.cornerRadius = 12
    return img
  }()
  
  let desStack : UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.spacing = 4
    return sv
  }()
  
  let genderLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 18)
    lbl.textColor = .white
    return lbl
  }()
  let statusLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 18)
    lbl.textColor = .white
    return lbl
  }()
  let speciesLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 18)
    lbl.textColor = .white
    return lbl
  }()
  let typeLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 18)
    lbl.textColor = .white
    return lbl
  }()
  
  let character: CharacterResponse.Character
      
  init(character: CharacterResponse.Character) {
      self.character = character
      super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }
  
  func setupUI() {
    navigationController?.navigationBar.isHidden = true
//    navigationItem.hidesBackButton = true
    navigationItem.leftItemsSupplementBackButton = false
    view.backgroundColor = .systemBackground
    
    titleLabel.text = character.name
    let imgUrl = URL(string: character.image)
    centerImg.kf.setImage(with: imgUrl)
    genderLabel.text = "Gender:\(character.gender)"
    statusLabel.text = "Status: \(character.status)"
    speciesLabel.text = "Species: \(character.species)"
    typeLabel.text = "Type: \(character.type)"
    
    
    
    backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    
    isSaved = BookmarkStorage.isBookmarked(character)
    updateBookmarkIcon()
    applyGradientBackground()
  }
  func setupConstraints() {
    view.addSubview(topStack)
    view.addSubview(centerStack)
    
    topStack.addArrangedSubview(backButton)
    topStack.addArrangedSubview(saveButton)
    
    centerStack.addArrangedSubview(titleLabel)
    centerStack.addArrangedSubview(centerImg)
    
    view.addSubview(desStack)
    
    [
      genderLabel,
      statusLabel,
      speciesLabel,
      typeLabel
    ].forEach(desStack.addArrangedSubview)
    
    
    
    topStack.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    centerStack.snp.makeConstraints { make in
      make.top.equalTo(topStack.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    centerImg.snp.makeConstraints { make in
      make.height.width.equalTo(350)
    }
    desStack.snp.makeConstraints { make in
      make.top.equalTo(centerImg.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    
  }
  
  func updateBookmarkIcon() {
      let icon = isSaved ? "bookmark.fill" : "bookmark"
      saveButton.setImage(UIImage(systemName: icon), for: .normal)
  }
  
  @objc
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc
  func save() {
    if isSaved {
      BookmarkStorage.removeBookmark(character)
    } else {
      BookmarkStorage.addBookmark(character)
    }
    
    isSaved.toggle()
    updateBookmarkIcon()
    
  }
}
