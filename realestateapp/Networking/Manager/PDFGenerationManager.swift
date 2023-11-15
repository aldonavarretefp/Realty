//
//  PDFGenerationManager.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 14/11/23.
//

import Foundation

class PDFManager {
    
    static let shared = PDFManager() // Singleton instance
    
    private init() {}

    func fetchPDF(from urlString: String, with bodyParameters: [String: Any]) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        } catch {
            throw NetworkError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
        
        if let mimeType = httpResponse.mimeType, mimeType == "application/pdf" {
            return data
        } else {
            throw NetworkError.invalidData
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case serverError
    case invalidData
    case encodingError
}
