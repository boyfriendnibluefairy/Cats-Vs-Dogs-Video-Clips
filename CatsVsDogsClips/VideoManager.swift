//
//  VideoManager.swift
//  This file contain everythin related to the videos.
//

import Foundation

// It must conform to the CaseIterable protocol so that we can
// use the .allCases property when we want to select all queries.
// We also conformed the enum to String so that we can easily convert
// the cases into string and use various String properties.
enum Query : String, CaseIterable {
    case cat, dog
}

// fetch data from API
class VideoManager : ObservableObject {
    // we use set because we only want to set this variable within
    // this class
    @Published private(set) var videos : [Video] = []
    @Published var selectedQuery : Query = Query.dog {
        // didSet is called whenever a new value is set on selectedQuery
        didSet {
            // done to repopulate the video array every time
            // selectedQuery changes
            Task.init{
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    // During initialization of this class, let's put a default query
    // for the findVideos function
    init(){
        Task.init{
            await findVideos(topic: selectedQuery)
        }
    }
    
    func findVideos(topic: Query) async {
        do {
            guard let url = URL(string:"https://api.pexels.com/videos/search?query=\(topic)&per_page=13&orientation=portrait") else {
                fatalError("Missing URL") }
            
            var urlRequest = URLRequest(url: url)
            // This is where the API key comes in
            urlRequest.setValue("<insert your generated API key from Pexels.com>", forHTTPHeaderField: "Authorization")
            
            // call the data
            // The function URLSession.shared.data() returns two outputs:
            // (1) actual data, and (2) the response whether request is
            // successful or not
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Before proceeding make sure that the response is 200 OK
            // which is consistent with REST Status Code
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error while fetching data")
            }
            
            // if response is OK, process the json data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            // 1st parameter: the model into which we want to decode our json data
            // 2nd parameter: actual data from http request
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            DispatchQueue.main.async{
                // set our published videos var above to [] to refresh it
                self.videos = []
                // Assign decodedData.videos to our published var videos above
                self.videos = decodedData.videos
            }
            
        } catch {
            print("Error fetching data from pexels.com : \(error)")
        }
    }
}

// The ff struct is used to handle the response coming from Pexel API.
// We conform the struct to Decodable so that we can decode JSON data
// coming from Pexel API.
struct ResponseBody : Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}

// We conform the Video struct to identifiable because if you examine
// the JSON documentation, the video struct has its own id property.
struct Video : Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User : Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile : Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
