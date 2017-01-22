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
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "imagefile",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
        },
            to: imagga_URL_content,
            headers: ["Authorization": headers_imagga_Authorization],
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .uploadProgress { progress in
                        progressCompletion(Float(progress.fractionCompleted))
                    }
                    upload
                        .validate()
                        .validate()
                    upload
                        .responseJSON { response in
                        // 1.Check if the response was successful; if not, print the error and call the completion handler.
                        guard response.result.isSuccess else {
                            print("Error while uploading file: \(response.result.error)")
                            completion([String](), [UIColor]())
                            return
                        }
                        // 2.Check each portion of the response, verifying the expected type is the actual type received. 
                        // Retrieve the firstFileID from the response. If firstFileID cannot be resolved, print out an error message 
                        // and call the completion handler.
                        guard
                            let responseJSON = response.result.value as? [String: Any],
                            let uploadedFiles = responseJSON["uploaded"] as? [[String: Any]],
                            let firstFile = uploadedFiles.first,
                            let firstFileID = firstFile["id"] as? String else {
                                print("Invalid information received from service")
                                completion([String](), [UIColor]())
                                return
                        }
                        print("Content uploaded with ID: \(firstFileID)")
                        // 3.Call the completion handler to update the UI. 
                        // At this point, you don’t have any downloaded tags or colors,
                        // so simply call this with empty data.
                        completion([String](), [UIColor]())
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }

}
