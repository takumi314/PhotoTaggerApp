//
//  ViewController.swift
//  PhotoTaggerApp
//
//  Created by NishiokaKohei on 2017/01/23.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {

    // Networking calls
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String], _ colors: [UIColor]) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print(image_data_failure_JPEG_representation)
            return
        }
        // statement
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "imagefile",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
        },
            to: imagga_URL_content,
            headers: ["Authorization": headers_imagga_Authorization],
            encodingCompletion: { encodingResult in
        }
        )
    }

}
