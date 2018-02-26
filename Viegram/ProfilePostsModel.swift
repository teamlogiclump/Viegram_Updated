//
//  ProfilePostsModel.swift
//
//  Created by Apple on 12/18/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ProfilePostsModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kProfilePostsModelPostIdKey: String = "post_id"
  private let kProfilePostsModelTypeKey: String = "type"
  private let kProfilePostsModelPhotoKey: String = "photo"

  // MARK: Properties
  public var postId: String?
  public var type: String?
  public var photo: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    postId = json[kProfilePostsModelPostIdKey].string
    type = json[kProfilePostsModelTypeKey].string
    photo = json[kProfilePostsModelPhotoKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = postId { dictionary[kProfilePostsModelPostIdKey] = value }
    if let value = type { dictionary[kProfilePostsModelTypeKey] = value }
    if let value = photo { dictionary[kProfilePostsModelPhotoKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.postId = aDecoder.decodeObject(forKey: kProfilePostsModelPostIdKey) as? String
    self.type = aDecoder.decodeObject(forKey: kProfilePostsModelTypeKey) as? String
    self.photo = aDecoder.decodeObject(forKey: kProfilePostsModelPhotoKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(postId, forKey: kProfilePostsModelPostIdKey)
    aCoder.encode(type, forKey: kProfilePostsModelTypeKey)
    aCoder.encode(photo, forKey: kProfilePostsModelPhotoKey)
  }

}
