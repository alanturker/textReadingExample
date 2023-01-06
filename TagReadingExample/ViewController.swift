//
//  ViewController.swift
//  TagReadingExample
//
//  Created by Türker Alan on 6.01.2023.
//

import Vision
import UIKit

class ViewController: UIViewController {
    
    var imageArray: [UIImage] = []
    var textLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addImage()
        setTextLabel()
        
        startRecognizeProcess()
    }

    
    
    private func setTextLabel() {
        textLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        textLabel.center = view.center
        textLabel.textColor = .black
        textLabel.text = "11111 \n"
        textLabel.numberOfLines = 0

        textLabel.textAlignment = .center
        
        view.addSubview(textLabel)
    }

    private func addImage() {
        let fourImage = UIImage(named: "4")!
        let fourPointOneImage = UIImage(named: "4.1")!
        let text = UIImage(named: "text")!
        let fiveImage = UIImage(named: "5")!
        let twoPointNineImage = UIImage(named: "2.9")!
        let threePointSevenImage = UIImage(named: "3.7")!

        imageArray.append(fourImage)
        imageArray.append(fourPointOneImage)
        imageArray.append(text)
        imageArray.append(fiveImage)
        imageArray.append(twoPointNineImage)
        imageArray.append(threePointSevenImage)
    }
    
    private func startRecognizeProcess() {
        imageArray.forEach { image in
//            let resizedImage = image.resize(to: CGSize(width: 640, height: 640))
            recognizeImage(image)
        }
    }
    
    private func recognizeImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                    error == nil else {
                DispatchQueue.main.async {
                    self?.textLabel.text = "blala"
                }
                return }
            
            let recognized = observations.compactMap { observation in
                return observation.topCandidates(1).first
            }
            
            let confidence = recognized.filter{$0.confidence > 0.3}
            
            let textArraySorted = confidence.sorted { $0.confidence > $1.confidence }
            
            let text = textArraySorted.first?.string
            textArraySorted.forEach { VNtext in
                let text = VNtext.string
                DispatchQueue.main.async {
                    self?.textLabel.text! += "\(text) \n"
                }
            }
           
        }
        request.recognitionLevel = .accurate
        
        //Process request
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}


extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
