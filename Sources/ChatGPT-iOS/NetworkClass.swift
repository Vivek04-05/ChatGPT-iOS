//
//  NetworkClass.swift
//
//
//  Created by Vivek Patel on 25/08/24.
//

import Foundation


 class NetworkClass {
    
    var request: URLRequest?
    
    init(){
        setUpRequest()
    }

    func setUpRequest() {
        guard let url = URL(string: APIUrl.ChatGPTUrl) else {
            return
        }
        
        self.request = URLRequest(url: url)
        self.request?.httpMethod = "POST"
        self.request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let apiKey = SecureStorageManager.shared.retrieveFromKeychain(key: Constants.ApiKey) {
                  self.request?.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
              } else {
                  print("API Key not found in Keychain")
              }
    }
    
    func getChatGPTResponse(prompt: String, completion: @escaping(Result<String, Error>)-> Void)  {
        guard var request = self.request else {
                    print("Request is not configured properly")
                    return
                }
        
        let parameter: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "message": [
                ["role": "system", "content": "You are interacting with a language model."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
        } catch {
            print("Failed to serialize request body: \(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkClassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                            completion(.success(responseString))
                        } else {
                            let error = NSError(domain: "NetworkClassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                            completion(.failure(error))
                        }
            
            
        }.resume()
        
        
        
    }
}
