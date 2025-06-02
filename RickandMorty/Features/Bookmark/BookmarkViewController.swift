//
//  BookmarkViewController.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 19.05.25.
//

import UIKit

class BookmarkViewController: UIViewController {
  
  var characters : [CharacterResponse.Character] = []
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Saved Characters"
    label.font = .systemFont(ofSize: 32, weight: .bold)
    return label
  }()
  
  let characterCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    let width = UIScreen.main.bounds.width
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCollectionViewCell")
    collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCollectionViewCell")
    collectionView.showsVerticalScrollIndicator = false
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
    setupUI()
    applyGradientBackground()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    characters = BookmarkStorage.getAllBookmarks()
    characterCollectionView.reloadData()
  }
  
  func setupUI() {
    view.backgroundColor = .systemPurple
    
    characterCollectionView.dataSource = self
    characterCollectionView.delegate = self
    characterCollectionView.isUserInteractionEnabled = true
  }
  func setupConstraints() {
    [
      titleLabel,
      characterCollectionView
    ].forEach(view.addSubview)
    
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
      
      characterCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
      characterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      characterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      characterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}



extension BookmarkViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if characters.isEmpty {
      return 1
    }
    else {
      return characters.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if characters.isEmpty {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
      cell.config(character: characters[indexPath.item])
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if characters.isEmpty {
      return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    else {
      let width: CGFloat = (collectionView.frame.width - 20) / 2
      return .init(width: width, height: 220)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedCharacter = characters[indexPath.row]
    let vc = DetailViewController(character: selectedCharacter)
    navigationController?.pushViewController(vc, animated: true)
  }
}

