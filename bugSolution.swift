func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return data
    } catch {
        throw error // Re-throw error for handling in the calling function
    }
}

enum NetworkError: Error {
    case badResponse(statusCode: Int)
    case otherError(Error)
}

Task { 
    do {
        let data = try await fetchData()
        // Process data
    } catch {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .badResponse(let statusCode):
                print("Bad response: \(statusCode)")
            case .otherError(let error):
                print("Other error: \(error)")
            }
        } else {
            print("Unexpected error: \(error)")
        }
    }
} 