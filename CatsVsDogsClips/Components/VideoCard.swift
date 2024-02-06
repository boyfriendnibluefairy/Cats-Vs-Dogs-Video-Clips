//
//  VideoCard.swift
//  CatsVsDogsClips
//
//  Created by GM Oca on 2/6/24.
//

import SwiftUI

struct VideoCard: View {
    
    var video:Video
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading){
                AsyncImage(url: URL(string:video.image)){ image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:160, height:260)
                        .cornerRadius(30)
                }placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(width:160, height:260)
                        .cornerRadius(30)
                }
                
                VStack(alignment: .leading){
                    Text("\(video.duration) sec")
                        .font(.caption).bold()
                    
                    Text("By \(video.user.name)")
                        .font(.caption).bold()
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(.white)
                .shadow(radius: 30)
                .padding()
            }
            
            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(60)
        }
    }
}

#Preview {
    VideoCard(video: previewVideo)
}
