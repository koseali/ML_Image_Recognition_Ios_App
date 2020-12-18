//
//  ViewController.swift
//  ML_Image_Recognition_Ios_App
//
//  Created by Ali Köse on 18.12.2020.
//

import UIKit

import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbExplain: UILabel!
    @IBOutlet weak var lbSecondexp: UILabel!
    var choosenImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func clickChange(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let ciImage = CIImage(image: imageView.image!){
            choosenImage = ciImage
            recognizeImage(image: ciImage)
        }
   
        
    }
    
    
    func recognizeImage(image: CIImage) {
            
            // 1) Request
            // 2) Handler
            
            lbExplain.text = "Finding ..."
            lbSecondexp.text = "Computing.."
            if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
                let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                    
                    if let results = vnrequest.results as? [VNClassificationObservation] {
                        if results.count > 0 {
                            
                            let topResult = results.first
                            let secondResult = results[1]
                            
                            DispatchQueue.main.async {
                                //
                                let confidenceLevel = (topResult?.confidence ?? 0) * 100
                                
                                let conf = round((secondResult.confidence ) * 100)
                                let rounded = Int (confidenceLevel * 100) / 100
                                
                                self.lbExplain.text = "\(rounded)% it's \(topResult!.identifier)"
                                self.lbSecondexp.text = "\(conf)% it's \(secondResult.identifier)"
                            }
                            
                        }
                        
                    }
                    
                }
                
                let handler = VNImageRequestHandler(ciImage: image)
                      DispatchQueue.global(qos: .userInteractive).async {
                        do {
                        try handler.perform([request])
                        } catch {
                            print("error")
                        }
                }
                
                
            }
            
          
            
        }
    
}

