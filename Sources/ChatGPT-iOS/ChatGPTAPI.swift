// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


public class ChatGPTAPI {
    
    private let apiKey: String
    private let organizationID: String?
    
    private let secureStorageManager = SecureStorageManager.shared
    
   public init(apiKey: String) {
        self.apiKey = apiKey
        self.organizationID = nil
        
        secureStorageManager.storeInKeychain(value: apiKey, key: Constants.ApiKey)
    }
    
   public init(apiKey: String, organizationID: String){
        self.apiKey = apiKey
        self.organizationID = organizationID
        
        secureStorageManager.storeInKeychain(value: apiKey, key: Constants.ApiKey)
        secureStorageManager.storeInKeychain(value: organizationID, key: Constants.OrganizationID)
    }
    
  public func getPromptResponse(prompt:String, completion: @escaping (Result<String, Error>) -> Void)
    {
        let networkClass = NetworkClass()
        networkClass.getChatGPTResponse(prompt: prompt, completion: completion)
    }
}
