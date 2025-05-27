//
//  UIImageView+ext.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  
  func setImage(urlString: String) {
    
    guard let url = URL(string: urlString) else { return }
//    if let cachedImage = imageCache.object(forKey: urlString as NSString) {
//      self.image = cachedImage
//      return
//    }
    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      if let error = error {
        print("Error downloading image: \(error)")
        return
      }
      
      guard let data = data else { return }
      DispatchQueue.main.async {
        print("success: \(urlString)")
        self?.image = UIImage(data: data)
      }
    }.resume()
  }
}


class ImageView: UIImageView {
  private let session: URLSession = URLSession.shared
  
  private var currentTask: URLSessionDataTask?
  func loadImage(urlString: String) {
    currentTask?.cancel()
    
    guard let url = URL(string: urlString) else { return }
    
    currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      if let error = error as? URLError, error.code != .cancelled {
        print("Image load failed: \(error)")
        return
      }
      
      guard let data = data, let image = UIImage(data: data) else { return }
      DispatchQueue.main.async {
        self?.image = image
      }
    }
    
    currentTask?.resume()
  }
  
  func cancel(request: URLRequest) {
    session.getAllTasks { tasks in
      tasks.filter { task in
        return task.originalRequest == request
      }.forEach {
        $0.cancel()
      }
    }
  }
}
