//
//  YoutubeVideoView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 17.04.2023.
//

import SwiftUI
import WebKit

struct YoutubeVideoView: UIViewRepresentable {
   private let youtubeVideoUrl: URL
    
    init(youtubeVideoUrl: URL) {
        self.youtubeVideoUrl = youtubeVideoUrl
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeVideoUrl))
    }
}
