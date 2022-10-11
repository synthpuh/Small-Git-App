//
//  DataFetcher.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation
import PKHUD

class DataFetcher {
    static func fetchData<T: Decodable>(urlString: String, completion: @escaping (T?) -> ()) {
        guard let url = URL(string: urlString),
              let accessToken = Defaults.accessToken else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        URLSession.shared
            .dataTask(with: request) { data, response, error in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        HUD.flash(.label("Error getting data, check your internet connection"), delay: 1.0)
                    }
                    return
                }
                if statusCode == 200 {
                    guard let data = data,
                          error == nil,
                          let result: T = try? JSONDecoder().decode(T.self, from: data) else {
                        DispatchQueue.main.async {
                            HUD.flash(.label("Error fetching data: \(error?.localizedDescription ?? "")"), delay: 1.0)
                        }
                        completion(nil)
                        return
                    }
                    completion(result)
                } else if statusCode == 401 {
                    DispatchQueue.main.async {
                        HUD.flash(.label("Need authentication"), delay: 0.8)
                    }
                }
            }.resume()
    }
}
