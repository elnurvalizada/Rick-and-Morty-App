//
//  HomeViewModel.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 30.05.25.
//

import Foundation

class HomeViewModel {
    private(set) var characters: [CharacterResponse.Character] = []
    
    var filters: [FilterModel] = [
        .init(name: "Gender", filters: ["Male", "Female", "Genderless", "Unknown"]),
        .init(name: "Status", filters: ["Alive", "Dead", "Unknown"]),
        .init(name: "Location", filters: ["Earth", "Citadel of Ricks", "Abadango", "Anatomy Park", "Bird World"])
    ]
    
    var selectedFilters: [String: String] = [:]
    
    var onCharactersUpdated: (() -> Void)?
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreData = true
    
    private var searchedText: String? = nil
    private let characterService = CharacterService()
    
    func loadCharacters(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        if reset {
            currentPage = 1
            hasMoreData = true
            characters.removeAll()
        }
        
        characterService.fetchCharacters(
            name: searchedText,
            currentFilters: selectedFilters,
            page: currentPage
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.characters += response.characters
                self.hasMoreData = response.info.next != nil
                self.onCharactersUpdated?()
            case .failure(let error):
                print("Error fetching characters: \(error)")
                self.onCharactersUpdated?()
            }
        }
    }
    
    func loadMoreCharactersIfNeeded(currentIndex: Int) {
        if currentIndex == characters.count - 1 && hasMoreData && !isLoading {
            currentPage += 1
            loadCharacters()
        }
    }
    
    func updateFilter(category: String, value: String) {
        selectedFilters[category.lowercased()] = value
        if let index = filters.firstIndex(where: { $0.name == category }) {
            filters[index].selectedValue = value
        }
        loadCharacters(reset: true)
    }
    
    func clearFilters() {
        selectedFilters.removeAll()
        for index in filters.indices {
            filters[index].selectedValue = nil
        }
        loadCharacters(reset: true)
    }
    
    func updateSearchText(_ text: String) {
        searchedText = text
        loadCharacters(reset: true)
    }
    
}
