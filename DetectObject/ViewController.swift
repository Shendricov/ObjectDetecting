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
    private var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let imageData = UIImage(named: "image")?.jpegData(compressionQuality: 1) {
//            network.getRequest(imageData: imageData)
//        }
        
        setupConstraints()
        macingObjectsArr()
    }

    func setupConstraints() {
        
        guard let imageForWork = UIImage(named: "image") else {
            print ("image not exist, issue in line \(#line)")
            return
        }
        self.image = imageForWork
        
        let imageSize: CGSize = image!.size
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = .red
        self.imageView.frame = CGRect(x: 0, y: 40, width: imageSize.width, height: imageSize.height)
            
    }
    
    
    func macingObjectsArr() {
        guard let jsonData = self.dataResponse.data(using: .utf8) else { return }
        let object = try? JSONDecoder().decode(TargetBody.self, from: jsonData)
        
        let findObject = object!.amazon.items[1]
        
        print("****************************")
        print(findObject.label)
        print("****************************")
        
        let amazone = object!.amazon
        let google = object!.google
        let edenAI = object!.eden
        
        guard let image = UIImage(named: "image") else {
            print("image not exist \(#line)")
            return
        }
        imageView.contentMode = .scaleAspectFit
        
        let objects = collectObjets(with: [amazone,google,edenAI], in: image)
        objects.forEach { print("\($0.key) with confident \($0.value.confidence)" ) }
        selectObject(with: objects["Elephant"])
        
    }
    
    
    private func collectObjets(with providers: [Provider], in image: UIImage) -> [String: ObjectInfoStruct] {
        var fullObjects: Dictionary<String, ObjectInfoStruct> = [:]
        for provider in providers {
            
            for item in provider.items where item.xMax != nil && item.yMax != nil {
                if fullObjects[item.label] != nil && fullObjects[item.label]!.confidence < item.confidence { fullObjects[item.label] = ObjectInfoStruct(confidence: item.confidence, location: culculateRect(for: item, in: image))
                } else { fullObjects[item.label] = ObjectInfoStruct(confidence: item.confidence, location: culculateRect(for: item, in: image))
                }
            }
        }
        return fullObjects
    }
    
    private func selectObject(with rect: ObjectInfoStruct?) {
        guard let rect = rect else {
            print("object not exist")
            return
        }
        let layer = CALayer()
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 3
        layer.frame = rect.location
        self.imageView.layer.addSublayer(layer)
    }
    
    private func culculateRect(for object: Item, in image: UIImage) -> CGRect {
        let viewBounds = imageView.bounds
        let imageSize = image.size
        let x: Double = Double(viewBounds.width) * object.xMin!
        let y: Double = Double(viewBounds.height) * object.yMin!
        let width: Double = Double(viewBounds.maxX) * object.xMax! - x
        let height: Double = Double(viewBounds.maxY) * object.yMax! - y - ((viewBounds.height - imageSize.height)/2)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private let dataResponse = """
 {"google":{"items":[{"label":"Animal","confidence":0.73002553,"x_min":0.4453125,"x_max":0.671875,"y_min":0.46289062,"y_max":0.98046875},{"label":"Animal","confidence":0.7263367,"x_min":0.31640625,"x_max":0.46875,"y_min":0.48046875,"y_max":0.98828125},{"label":"Animal","confidence":0.707196,"x_min":0.122558594,"x_max":0.32226562,"y_min":0.734375,"y_max":0.98828125},{"label":"Animal","confidence":0.7003303,"x_min":0.6328125,"x_max":0.74609375,"y_min":0.5390625,"y_max":0.99609375},{"label":"Zebra","confidence":0.69148576,"x_min":0.6328125,"x_max":0.74609375,"y_min":0.5390625,"y_max":0.99609375},{"label":"Giraffe","confidence":0.6214695,"x_min":0.42382812,"x_max":0.50390625,"y_min":0.015991211,"y_max":0.5703125},{"label":"Animal","confidence":0.6127845,"x_min":0.16503906,"x_max":0.36328125,"y_min":0.5625,"y_max":0.99609375}],"status":"success","cost":0.00225},"amazon":{"items":[{"label":"Animal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Lion","confidence":0.9971595001220703,"x_min":0.316506028175354,"x_max":0.4678440988063812,"y_min":0.4668615758419037,"y_max":0.9970662891864777},{"label":"Mammal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Wildlife","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Zebra","confidence":0.9912814331054688,"x_min":0.6317039728164673,"x_max":0.7473124265670776,"y_min":0.5369468331336975,"y_max":0.9999999105930328},{"label":"Field","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Grassland","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Nature","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Outdoors","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cattle","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cow","confidence":0.9520645141601562,"x_min":0.44207435846328735,"x_max":0.6750703603029251,"y_min":0.46680060029029846,"y_max":0.9872698485851288},{"label":"Livestock","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Bird","confidence":0.9331747436523438,"x_min":0.8109565377235413,"x_max":0.9091107845306396,"y_min":0.7192604541778564,"y_max":0.94035604596138},{"label":"Elephant","confidence":0.8966658020019531,"x_min":0.6058966517448425,"x_max":0.9555527567863464,"y_min":0.30511942505836487,"y_max":0.7891389429569244},{"label":"Giraffe","confidence":0.8901195526123047,"x_min":0.4326402246952057,"x_max":0.4979015812277794,"y_min":0.020895464345812798,"y_max":0.5603390764445066},{"label":"Canine","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Dog","confidence":0.8622650909423828,"x_min":0.43065571784973145,"x_max":0.5808281749486923,"y_min":0.8726358413696289,"y_max":0.999853789806366},{"label":"Pet","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Antelope","confidence":0.8347011566162109,"x_min":0.12192397564649582,"x_max":0.31728144735097885,"y_min":0.7367243766784668,"y_max":0.9999999105930328},{"label":"Cheetah","confidence":0.73220458984375,"x_min":0.16494746506214142,"x_max":0.35116949677467346,"y_min":0.5838196277618408,"y_max":0.9902676045894623}],"status":"success","cost":0.001},"eden-ai":{"items":[{"label":"Cow","confidence":0.9520645141601562,"x_min":0.44207435846328735,"x_max":0.6750703603029251,"y_min":0.46680060029029846,"y_max":0.9872698485851288},{"label":"Lion","confidence":0.9971595001220703,"x_min":0.316506028175354,"x_max":0.4678440988063812,"y_min":0.4668615758419037,"y_max":0.9970662891864777},{"label":"Antelope","confidence":0.8347011566162109,"x_min":0.12192397564649582,"x_max":0.31728144735097885,"y_min":0.7367243766784668,"y_max":0.9999999105930328},{"label":"Zebra","confidence":0.9912814331054688,"x_min":0.6317039728164673,"x_max":0.7473124265670776,"y_min":0.5369468331336975,"y_max":0.9999999105930328},{"label":"Giraffe","confidence":0.6214695,"x_min":0.42382812,"x_max":0.50390625,"y_min":0.015991211,"y_max":0.5703125},{"label":"Cheetah","confidence":0.73220458984375,"x_min":0.16494746506214142,"x_max":0.35116949677467346,"y_min":0.5838196277618408,"y_max":0.9902676045894623},{"label":"Animal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Mammal","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Wildlife","confidence":0.9971595001220703,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Field","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Grassland","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Nature","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Outdoors","confidence":0.9728433227539063,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Cattle","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Livestock","confidence":0.9520645141601562,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Bird","confidence":0.9331747436523438,"x_min":0.8109565377235413,"x_max":0.9091107845306396,"y_min":0.7192604541778564,"y_max":0.94035604596138},{"label":"Elephant","confidence":0.8966658020019531,"x_min":0.6058966517448425,"x_max":0.9555527567863464,"y_min":0.30511942505836487,"y_max":0.7891389429569244},{"label":"Giraffe","confidence":0.8901195526123047,"x_min":0.4326402246952057,"x_max":0.4979015812277794,"y_min":0.020895464345812798,"y_max":0.5603390764445066},{"label":"Canine","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null},{"label":"Dog","confidence":0.8622650909423828,"x_min":0.43065571784973145,"x_max":0.5808281749486923,"y_min":0.8726358413696289,"y_max":0.999853789806366},{"label":"Pet","confidence":0.8622650909423828,"x_min":null,"x_max":null,"y_min":null,"y_max":null}],"status":"success","cost":0.0}}
"""
    
}

