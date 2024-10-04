//
//  ViewController.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 26.09.2024.
//

import UIKit

class ViewController: UIViewController {

    let network = NetworkManager(session: URLSession.shared)
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let imageData = UIImage(named: "image")?.jpegData(compressionQuality: 1) {
//            network.getRequest(imageData: imageData)
//        }
        testFunction()
        
    }

    func testFunction() {
        guard let jsonData = self.dataResponse.data(using: .utf8) else { return }
        let object = try? JSONDecoder().decode(TargetBody.self, from: jsonData)
        
        let findObject = object!.amazon.items[1]
        
        print("****************************")
        print(findObject.label)
        print("****************************")
        var index = 0
        for item in object!.amazon.items {
            print("\(item.label) index \(index)")
            index += 1
        }
        
        
        print("max X \(String(describing: findObject.xMax))")
        let xMax = findObject.xMax!
        print("max Y \(String(describing: findObject.yMax))")
        let yMax = findObject.yMax!
        print("min X \(String(describing: findObject.xMin))")
        let xMin = findObject.xMin!
        print("min Y \(String(describing: findObject.yMin))")
        let yMin = findObject.yMin!
        
        guard let image = UIImage(named: "image") else {
            print("image not exist \(#line)")
            return
        }
        imageView.contentMode = .scaleAspectFit
        let imageSize = image.size
        print("image size is \(imageSize)")
        
        let viewBounds = imageView.bounds
        print("view size is \(imageView.bounds.size)")
        imageView.image = image
        imageView.clipsToBounds = false
        
        let findRect = CALayer()
        findRect.borderColor = UIColor.red.cgColor
        findRect.borderWidth = 3
        
        let xPosition: Double = Double(viewBounds.width) * xMin
        let yPosition: Double = Double(viewBounds.height) * yMin
        let width: Double = Double(viewBounds.maxX) * xMax - xPosition
        let height: Double = Double(viewBounds.maxY) * yMax - yPosition - ((viewBounds.height - imageSize.height)/2)
        
        print("x: \(xPosition) y: \(yPosition) width \(width) heigh \(height)")
        
        findRect.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        
        imageView.layer.addSublayer(findRect)
    }


    
    let dataResponse = """
 {"google":{"items":[{"label":"Animal","confidence":0.73002553,"x_min":0.4453125,"x_max":0.671875,"y_min":0.46289062,"y_max":0.98046875},{"label":"Animal","confidence":0.7263367,"x_min":0.31640625,"x_max":0.46875,"y_min":0.48046875,"y_max":0.98828125},{"label":"Animal","confidence":0.707196,"x_min":0.122558594,"x_max":0.32226562,"y_min":0.734375,"y_max":0.98828125},{"label":"Animal","confidence":0.7003303,"x_min":0.6328125,"x_max":0.74609375,"y_min":0.5390625,"y_max":0.99609375},{"label":"Zebra","confidence":0.69148576,"x_min":0.6328125,"x_max":0.74609375,"y_min":0.5390625,"y_max":0.99609375},{"label":"Giraffe","confidence":0.6214695,"x_min":0.42382812,"x_max":0.50390625,"y_min":0.015991211,"y_max":0.5703125},{"label":"Animal","confidence":0.6127845,"x_min":0.16503906,"x_max":0.36328125,"y_min":0.5625,"y_max":0.99609375}],"status":"success","cost":0.00225},"amazon":{"items":[{"label":"Animal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Lion","confidence":0.9971595001220703,"x_min":0.316506028175354,"x_max":0.4678440988063812,"y_min":0.4668615758419037,"y_max":0.9970662891864777},{"label":"Mammal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Wildlife","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Zebra","confidence":0.9912814331054688,"x_min":0.6317039728164673,"x_max":0.7473124265670776,"y_min":0.5369468331336975,"y_max":0.9999999105930328},{"label":"Field","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Grassland","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Nature","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Outdoors","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cattle","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cow","confidence":0.9520645141601562,"x_min":0.44207435846328735,"x_max":0.6750703603029251,"y_min":0.46680060029029846,"y_max":0.9872698485851288},{"label":"Livestock","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Bird","confidence":0.9331747436523438,"x_min":0.8109565377235413,"x_max":0.9091107845306396,"y_min":0.7192604541778564,"y_max":0.94035604596138},{"label":"Elephant","confidence":0.8966658020019531,"x_min":0.6058966517448425,"x_max":0.9555527567863464,"y_min":0.30511942505836487,"y_max":0.7891389429569244},{"label":"Giraffe","confidence":0.8901195526123047,"x_min":0.4326402246952057,"x_max":0.4979015812277794,"y_min":0.020895464345812798,"y_max":0.5603390764445066},{"label":"Canine","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Dog","confidence":0.8622650909423828,"x_min":0.43065571784973145,"x_max":0.5808281749486923,"y_min":0.8726358413696289,"y_max":0.999853789806366},{"label":"Pet","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Antelope","confidence":0.8347011566162109,"x_min":0.12192397564649582,"x_max":0.31728144735097885,"y_min":0.7367243766784668,"y_max":0.9999999105930328},{"label":"Cheetah","confidence":0.73220458984375,"x_min":0.16494746506214142,"x_max":0.35116949677467346,"y_min":0.5838196277618408,"y_max":0.9902676045894623}],"status":"success","cost":0.001},"eden-ai":{"items":[{"label":"Cow","confidence":0.9520645141601562,"x_min":0.44207435846328735,"x_max":0.6750703603029251,"y_min":0.46680060029029846,"y_max":0.9872698485851288},{"label":"Lion","confidence":0.9971595001220703,"x_min":0.316506028175354,"x_max":0.4678440988063812,"y_min":0.4668615758419037,"y_max":0.9970662891864777},{"label":"Antelope","confidence":0.8347011566162109,"x_min":0.12192397564649582,"x_max":0.31728144735097885,"y_min":0.7367243766784668,"y_max":0.9999999105930328},{"label":"Zebra","confidence":0.9912814331054688,"x_min":0.6317039728164673,"x_max":0.7473124265670776,"y_min":0.5369468331336975,"y_max":0.9999999105930328},{"label":"Giraffe","confidence":0.6214695,"x_min":0.42382812,"x_max":0.50390625,"y_min":0.015991211,"y_max":0.5703125},{"label":"Cheetah","confidence":0.73220458984375,"x_min":0.16494746506214142,"x_max":0.35116949677467346,"y_min":0.5838196277618408,"y_max":0.9902676045894623},{"label":"Animal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Mammal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Wildlife","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Field","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Grassland","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Nature","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Outdoors","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cattle","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Livestock","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Bird","confidence":0.9331747436523438,"x_min":0.8109565377235413,"x_max":0.9091107845306396,"y_min":0.7192604541778564,"y_max":0.94035604596138},{"label":"Elephant","confidence":0.8966658020019531,"x_min":0.6058966517448425,"x_max":0.9555527567863464,"y_min":0.30511942505836487,"y_max":0.7891389429569244},{"label":"Giraffe","confidence":0.8901195526123047,"x_min":0.4326402246952057,"x_max":0.4979015812277794,"y_min":0.020895464345812798,"y_max":0.5603390764445066},{"label":"Canine","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Dog","confidence":0.8622650909423828,"x_min":0.43065571784973145,"x_max":0.5808281749486923,"y_min":0.8726358413696289,"y_max":0.999853789806366},{"label":"Pet","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null}],"status":"success","cost":0.0}}
"""
    
}

