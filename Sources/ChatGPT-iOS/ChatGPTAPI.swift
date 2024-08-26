// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


class ChatGPTAPI {
    
    private let apiKey: String
    private let organizationID: String?
    
    private let secureStorageManager = SecureStorageManager.shared
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.organizationID = nil
        
        secureStorageManager.storeInKeychain(value: apiKey, key: Constants.ApiKey)
    }
    
    init(apiKey: String, organizationID: String){
        self.apiKey = apiKey
        self.organizationID = organizationID
        
        secureStorageManager.storeInKeychain(value: apiKey, key: Constants.ApiKey)
        secureStorageManager.storeInKeychain(value: organizationID, key: Constants.OrganizationID)
    }
    
    func getPromptResponse(prompt:String, completion: @escaping (Result<String, Error>) -> Void)
    {
        let networkClass = NetworkClass()
        networkClass.getChatGPTResponse(prompt: prompt, completion: completion)
    }
}
