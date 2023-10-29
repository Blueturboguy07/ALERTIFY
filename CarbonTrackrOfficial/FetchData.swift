import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

class FetchData {
    
    let database = Firestore.firestore()
    
    func getStudentData(username: String?, password: String?, completion: @escaping (Result<[String], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "friscoisdhacapi.vercel.app"
        components.path = "/api/info"
        components.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        
        if let url = components.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "FetchDataError", code: 404, userInfo: nil)))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(StudentInfo.self, from: data)
                    let studentData = [result.name, result.campus]
                    completion(.success(studentData))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "FetchDataError", code: 400, userInfo: nil)))
        }
    }
}
