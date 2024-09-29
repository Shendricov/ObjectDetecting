//
//  ViewController.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 26.09.2024.
//

import UIKit

class ViewController: UIViewController {

    private let start = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detectObject = NetworkManager(session: URLSession.shared)
        if let imageData = UIImage(named: "image")?.jpegData(compressionQuality: 1) {
            detectObject.getRequest(imageData: imageData)
        }
        
        
        
    }


}

