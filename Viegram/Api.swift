//
//  Api.swift
//  ForgetMeNot
//
//  Created by Relinns on 28/07/16.
//  Copyright © 2016 Relinns. All rights reserved.
//


typealias ServiceResponse = (Data?, Error?,URLResponse?) -> Void

import UIKit
import Alamofire
import SwiftyJSON

class Api: NSObject {
    
    static let sharedInstance = Api()
  
    class func requestPOST(_ strURL : String, params : Parameters?, headers : [String : String]?, success:@escaping (JSON, _ statusCode: Int) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL, params!, headers!)
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                let statusCode = JSON(responseObject.response?.statusCode ?? 404).intValue
                
                success(resJson, statusCode)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    func getJson (url: String,params: String,Method:String,onCompletion:@escaping (ServiceResponse)){
        
        var request = URLRequest(url: URL(string: url)! as URL)
        request.httpMethod = Method
        request.httpBody = params.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            onCompletion(data as Data?, error as Error?,response)
        })
        task.resume()
        
    }
    
    func makeMultiPartApiCall(url: String,params: [String:String],imageNameParam:String, image:UIImage?,onCompletion:@escaping (ServiceResponse)){
        
        let myUrl = NSURL(string: url);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = params
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        


        request.httpBody = createBodyWithParameters(parameters: param,imageName: imageNameParam, filePathKey: "file", imageDataKey: image, boundary: boundary) as Data
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            onCompletion(data  as Data?, error as Error?,response)
        })
        
        task.resume()
        
    }

    func createBodyWithParameters(parameters: [String: String]?,imageName:String, filePathKey: String?, imageDataKey: UIImage?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if imageDataKey != nil {
            
        let imageData = UIImageJPEGRepresentation(imageDataKey!, 1)
        
        let filename = "post.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func getCountryArray() -> NSArray?{
        if let path = Bundle.main.path(forResource: "isd", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                    print("serialization failed in get country code data")
                    return  nil
                }
                print(json)
                return json
                
            } catch let error {
                print(error.localizedDescription)
                return nil
                
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
    

}



