

import UIKit

class NetworkManager {
    
    // these two lines make it a singleton
    static let shared = NetworkManager()
    
    let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=10&page=\(page)"
        
        // check URL is valid
        guard let url = URL(string: endpoint) else {
            completed(nil, "URL is invalid")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(nil, "There was an error. Check internet connection.")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Error - something other than 200.")
                return
            }
            
            guard let data = data else {
                completed(nil, "Data received was invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "Data received was invalid")
            }

        }
        
        task.resume()
        
    }
    
    
}
