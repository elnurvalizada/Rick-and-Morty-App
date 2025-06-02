//
//  HomeViewController.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit
import SnapKit

//#Preview {
//  HomeViewController()
//}

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var topViewHeightConstraint: NSLayoutConstraint? = nil
    
    var lastContentOffset: CGFloat = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rick and Morty"
        label.font = .systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.backgroundColor = .clear
        searchBar.placeholder = "Search..."
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
        }
        return searchBar
    }()
    
    let filterStack : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
        sv.spacing = 5
        return sv
    }()
    
    let removeFilterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let width = UIScreen.main.bounds.width
        layout.sectionInset = .init(top: 0, left: 0, bottom: 5, right: 20)
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = CGSize(width: width/2.5, height: 30)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilteredCollectionViewCell.self, forCellWithReuseIdentifier: "FilteredCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        return collectionView
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
    
    private let topView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
        
        viewModel.onCharactersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.characterCollectionView.reloadData()
            }
        }
        viewModel.loadCharacters()
    }
    
    func setupUI() {
        applyGradientBackground()
        view.backgroundColor = .systemPurple
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        
        searchBar.delegate = self
        
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        characterCollectionView.isUserInteractionEnabled = true
        
        removeFilterButton.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)
        removeFilterButton.isHidden = true
    }
    
    func setupConstraints() {
        
        [
            topView,
            characterCollectionView
        ].forEach(view.addSubview)
        
        [
            titleLabel,
            searchBar,
            filterStack
        ].forEach(topView.addSubview)
        
        [
            removeFilterButton,
            filterCollectionView
        ].forEach(filterStack.addArrangedSubview)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: topView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            filterStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterStack.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            filterStack.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            filterStack.heightAnchor.constraint(equalToConstant: 36),
            filterStack.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            characterCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 12),
            characterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            characterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            characterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
        
        topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: 0)
        topViewHeightConstraint?.isActive = false
    }
    
    
    func loadCharacters(page: Int) {
        
    }
    
    func showGenderFilter(from sourceView: UIView, filters: [String], filtertype: String, index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        filters.forEach { filter in
            alert.addAction(UIAlertAction(title: filter, style: .default) { _ in
                self.viewModel.updateFilter(category: filtertype, value: filter)
                self.removeFilterButton.isHidden = false
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    func removeFilter() {
        viewModel.clearFilters()
        removeFilterButton.isHidden = true
    }
}



extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func collectionType(for collectionView: UICollectionView) -> HomeCollectionType {
            guard let type = HomeCollectionType.from(collectionView, in: self) else {
                fatalError("Unknown collection view")
            }
            return type
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionType(for: collectionView) {
        case .character:
            return viewModel.characters.count > 0 ? viewModel.characters.count : 1
        case .filter:
            return viewModel.filters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionType(for: collectionView) {
        case .character:
            if viewModel.characters.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
            cell.config(character: viewModel.characters[indexPath.item])
            return cell
        case .filter:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredCollectionViewCell", for: indexPath) as! FilteredCollectionViewCell
            cell.config(title: viewModel.filters[indexPath.row].name, selectedValue: viewModel.filters[indexPath.row].selectedValue)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionType(for: collectionView) {
        case .character:
            let width: CGFloat = (collectionView.frame.width - 20) / 2
            return .init(width: width, height: 220)
        case .filter:
            let width: CGFloat = (collectionView.frame.width + 20) / 3
            return .init(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionType(for: collectionView) {
        case .character:
            let selectedCharacter = viewModel.characters[indexPath.row]
            let vc = DetailViewController(character: selectedCharacter)
            navigationController?.pushViewController(vc, animated: true)
        case .filter:
            showGenderFilter(from: self.view, filters: viewModel.filters[indexPath.row].filters, filtertype: viewModel.filters[indexPath.row].name, index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionType(for: collectionView) {
        case .character:
            viewModel.loadMoreCharactersIfNeeded(currentIndex: indexPath.item)
        case .filter:
            break
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if characterCollectionView == scrollView && scrollView.contentOffset.y > 0 {
            lastContentOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if characterCollectionView == scrollView {
            if lastContentOffset > scrollView.contentOffset.y {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.showTopView()
                    self?.view.layoutIfNeeded()
                }, completion: nil)
            } else if lastContentOffset < scrollView.contentOffset.y {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.hideTopView()
                    self?.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    
    private func showTopView() {
        topView.alpha = 1
        topViewHeightConstraint?.isActive = false
    }
    
    private func hideTopView() {
        topView.alpha = 0
        topViewHeightConstraint?.isActive = true
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
}
