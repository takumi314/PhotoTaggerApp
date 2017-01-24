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
                completion: @escaping (_ tags: [String], _ colors: [PhotoColor]) -> Void) {
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
                            completion([String](), [PhotoColor]())
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
                                completion([String](), [PhotoColor]())
                                return
                        }
                        print("Content uploaded with ID: \(firstFileID)")
                        // 3.Call the completion handler to update the UI. 
                        // At this point, you don’t have any downloaded tags or colors,
                        // so simply call this with empty data.
                        self.downloadTags(contentID: firstFileID) { tags in
                            self.downloadColors(contentID: firstFileID) { colors in
                                completion(tags, colors)
                            }
//                            completion(tags, [PhotoColor]())
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }

    func downloadTags(contentID: String, completion: @escaping ([String]) -> Void) {
        Alamofire
            .request(imagga_URL_tagging,
                     method: .get,
                     parameters: ["content": contentID],
                     headers: ["Authorizzation": headers_imagga_Authorization]
        )
        .responseJSON { response in
            // 1. Check if the response was successful; if not, print the error and call the completion handler.
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                completion([String]())
                return
            }
            // 2. Check each portion of the response, verifying the expected type is the actual type received.
            // Retrieve the tagsAndConfidences information from the response. If tagsAndConfidences cannot be resolved, 
            // print out an error message and call the completion handler.
            guard
                let responseJSON = response.result.value as? [String: Any],
                let results = responseJSON["result"] as? [[String: Any]],
                let firstObject = results.first,
                let tagsAndConfidences = firstObject["tags"] as? [[String: Any]] else {
                print("Invalid tag information received from the service")
                completion([String]())
                return
            }

            // 3. Iterate over each dictionary object in the tagsAndConfidences array, 
            // retrieving the value associated with the tag key.
            let tags = tagsAndConfidences.flatMap({ dict in
                return dict["tags"] as? String
            })

            // 4. Call the completion handler passing in the tags received from the service.
            completion(tags)
        }
    }

    func downloadColors(contentID: String, completion: @escaping ([PhotoColor]) -> Void) {
        Alamofire.request(imagga_URL_colors,
                          method: .get,
                          parameters: ["content": contentID],
                          // 1. Be sure to replace Basic xxx with your actual authorization header.
                          headers: ["Autorizaion": headers_imagga_Authorization]
        )
        .responseJSON { response in
            // 2. Check the response was successful; if not, print the error and call the completion handler.
            guard response.result.isSuccess else {
                print("Error while fetching colors: \(response.result.error)")
                completion([PhotoColor]())
                return
            }
            // 3. Check each portion of the response, verifying the expected type is the actual type received. 
            // Retrieve the imageColors information from the response. 
            // If imageColors cannot be resolved, print out an error message and call the completion handler.
            guard
                let responseJSON = response.result.value as? [String: Any],
                let results = responseJSON["results"] as? [[String: Any]],
                let firstResult = results.first,
                let info = firstResult["info"] as? [String: Any],
                let imageColors = info["image_colors"] as? [[String: Any]] else {
                    print("Invalid color information received from service")
                    completion([PhotoColor]())
                    return
            }

            // 4. Using flatMap again, you iterate over the returned imageColors, 
            // transforming the data into PhotoColor objects which pairs colors in the RGB format with the color name as a string. 
            // Note the provided closure allows returning nil values since flatMap will simply ignore them.
            let photoColors = imageColors.flatMap({ (dict) -> PhotoColor? in
                guard let r = dict["r"] as? String,
                    let g = dict["g"] as? String,
                    let b = dict["b"] as? String,
                    let closestPaletteColor = dict["closest_palette_colo"] as? String else {
                        return nil
                }

                return PhotoColor(red: Int(r),
                                  green: Int(g),
                                  blue: Int(b),
                                  colorName: closestPaletteColor)
            })

            completion(photoColors)
        }
    }

}
