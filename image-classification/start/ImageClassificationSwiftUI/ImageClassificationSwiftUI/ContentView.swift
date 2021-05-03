//
//  ContentView.swift
//  ImageClassificationSwiftUI
//
//  Created by Mohammad Azam on 2/3/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let photos = ["banana","tiger","bottle"]
    @State private var currentIndex: Int = 0
	@State private var classificationLabel: String = ""
	
	let model = MobileNetV2()
	
	
	private func performImageClassification() {
		let currentImageName = photos[currentIndex]
		guard let image = UIImage(named: currentImageName),
			  let resizedImage = image.resizeTo(size: CGSize(width: 224, height: 224)),
			  let buffer = resizedImage.toBuffer() else { return }
		
		let output = try? model.prediction(image: buffer)
		
		if let output = output {
//			classificationLabel = output.classLabel
			
			//sort dictionary by its values
			let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
			
			// cycle through the array of dictionaries and get the values for each item
			let result = results.map { (key, value) in
				return "\(key) = \(value * 100)%"
			}.joined(separator: "\n")
			
			
			classificationLabel = result
		}
	}
	
    
    var body: some View {
        VStack {
			
            Image(photos[currentIndex])
            .resizable()
                .frame(width: 200, height: 200)
			
            HStack {
                Button("Previous") {
                    
                    if self.currentIndex >= self.photos.count {
                        self.currentIndex = self.currentIndex - 1
                    } else {
                        self.currentIndex = 0
                    }
                    
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 100)
                
                Button("Next") {
                    if self.currentIndex < self.photos.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    } else {
                        self.currentIndex = 0
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .frame(width: 100)
                .background(Color.gray)
                .cornerRadius(10)
            
                
                
            }.padding()
			
			
            Button("Classify") {
				performImageClassification()
                
            }.padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Text(classificationLabel)
				.padding()
//				.font(.largeTitle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
