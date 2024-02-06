//
//  CatsVsDogsClips ContentView
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var videoManager = VideoManager()
    // for LazyVGrid
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 19)]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                ScrollView{
                    
                    // show progress bar while videos
                    // are loading
                    if videoManager.videos.isEmpty {
                        ProgressView()
                    } else {
                        LazyVGrid(columns: columns, spacing: 19) {
                            ForEach(videoManager.videos, id: \.id){ video in
                                NavigationLink(){
                                    VideoView(video: video)
                                } label: {
                                    VideoCard(video: video)
                                }
                            }
                        }
                        .padding()
                    }
                    //VideoCard(video: previewVideo)
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                HStack{
                    ForEach(Query.allCases, id: \.self){ searchQuery in
                        QueryTag(query: searchQuery, isSelected: videoManager.selectedQuery == searchQuery)
                            .onTapGesture{
                                videoManager.selectedQuery = searchQuery
                            }
                    }
                }
                
            }
            .background(Color("AccentColor"))
        }
    }
}

#Preview {
    ContentView()
}
