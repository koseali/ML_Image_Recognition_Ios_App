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
            recognizeImage(image: ciImage)
        }
   
        
    }
    
    
    func recognizeImage(image : CIImage)  {
        // 1 request istek oluştur
        // reponse oluştur Handler et
        
        if let model = try?  VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { (VNRequest, error) in
                if error != nil{
                   // let alert = UIAlertAction(title: "Error", style: UIAlertAction.Style.default, handler: nil)
                    
                }
                else{
                    if let results = VNRequest.results as? [VNClassificationObservation]{
                        if results.count > 0 {
                            let topResult = results.first
                            DispatchQueue.main.async {
                                let confidenceLevel = topResult?.confidence ?? 0 * 100
                                self.lbExplain.text = "\(confidenceLevel)% it is  \(topResult!.identifier)"
                            }
                        
                        }
                            
                    }
                }
            
            }
            
        }
        
       
    }
    
    
    
}

