//
//  BookmarkStorage.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 19.05.25.
//
import Foundation

class BookmarkStorage {
  
    private static var fileUrl: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("test.json")
    }
  
    static func addBookmark(_ character: CharacterResponse.Character) {
        guard let url = fileUrl else { return }

        var bookmarks: [CharacterResponse.Character] = []

        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                bookmarks = try JSONDecoder().decode([CharacterResponse.Character].self, from: data)
            } catch {
                print("Failed to decode existing bookmarks: \(error)")
            }
        }

        if bookmarks.contains(where: { $0.id == character.id }) {
            return
        }

        bookmarks.append(character)

        do {
            let data = try JSONEncoder().encode(bookmarks)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save bookmark: \(error.localizedDescription)")
        }
    }
  
  static func isBookmarked(_ character: CharacterResponse.Character) -> Bool {
      guard let url = fileUrl else { return false }

      if FileManager.default.fileExists(atPath: url.path) {
          do {
              let data = try Data(contentsOf: url)
              let bookmarks = try JSONDecoder().decode([CharacterResponse.Character].self, from: data)
              return bookmarks.contains(where: { $0.id == character.id })
          } catch {
              print("Failed to read bookmarks: \(error)")
          }
      }
      return false
  }
  
  static func removeBookmark(_ character: CharacterResponse.Character) {
      guard let url = fileUrl else { return }

      do {
          let data = try Data(contentsOf: url)
          var bookmarks = try JSONDecoder().decode([CharacterResponse.Character].self, from: data)

          bookmarks.removeAll { $0.id == character.id }
          let updatedData = try JSONEncoder().encode(bookmarks)
          try updatedData.write(to: url, options: .atomic)
      } catch {
          print("\(error.localizedDescription)")
      }
  }
  
  static func getAllBookmarks() -> [CharacterResponse.Character] {
      guard let url = fileUrl else { return [] }

      do {
          let data = try Data(contentsOf: url)
          let bookmarks = try JSONDecoder().decode([CharacterResponse.Character].self, from: data)
          return bookmarks
      } catch {
          print("Failed to load bookmarks: \(error.localizedDescription)")
          return []
      }
  }
}
