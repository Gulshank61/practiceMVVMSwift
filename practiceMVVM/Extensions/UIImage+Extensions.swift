//
//  UIImage+Extensions.swift
//  practiceMVVM
//
//  Created by Gulshan Khandale  on 21/08/24.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: String) {
        guard let imageURL = URL(string: url) else {
           
            return
        }
        
        let downloadTask = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed To Load Image: \(error?.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
        }
        downloadTask.resume()
    }
}
