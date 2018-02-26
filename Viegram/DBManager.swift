//
//  DBManager.swift
//  Practice Dairy
//
//  Created by user on 26/10/16.
//  Copyright © 2016 Rohit Garg. All rights reserved.
//

import UIKit

struct TimeLineModel {
 
    var tID = String()
    var profile_image = String()
    var post_id = String()
    var userid = String()
    var second_userid = String()
    var post_like = String()
    var location = String()
    var first_display_name = String()
    var post_points = String()
    var first_user_profile_image = String()
    var caption = String()
    var date_time = String()
    var time_ago = String()
    
    var post_type = String()
    var image_width = String()
    var display_name = String()
    
    var photo = String()
    var first_caption = String()
    var image_height = String()
    
    var file_type = String()
     var second_name = String()
    
     var video = String()
    
     var multiple_images = String()
     var x_cord = String()
     var y_cord = String()
}


class DBManager: NSObject {
    

    
    let tID = "tID"
    let profile_image = "profile_image"
    let post_id = "post_id"
    let userid = "userid"
    let second_userid = "second_userid"
    let post_like = "post_like"
    let location = "location"
    let first_display_name = "first_display_name"
    let post_points = "post_points"
    let first_user_profile_image = "first_user_profile_image"
    let caption = "caption"
    let date_time = "date_time"
    let time_ago = "time_ago"
    
    let post_type = "post_type"
    let image_width = "image_width"
    let display_name = "display_name"

    let photo = "photo"
    let first_caption = "first_caption"
    let image_height = "image_height"
    
    let file_type = "file_type"
    var second_name = "second_name"
    var video = "video"
    var multiple_images = "multiple_images"
    var x_cord = "x_cord"
    var y_cord = "y_cord"
  
    static let shared : DBManager = DBManager()
    
    let databaseFileName = "databases.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    override init(){
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print(pathToDatabase)
        standard.set(pathToDatabase, forKey: "path")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                        let createTableQuery = "create table timeline_posts (\(tID) integer primary key autoincrement not null, \(profile_image) text , \(post_id) text , \(userid) text , \(second_userid) text,\(post_like) text,\(location) text,\(first_display_name) text,\(post_points) text ,\(first_user_profile_image) text,\(caption) text,\(date_time) text ,\(time_ago) text,\(post_type) text,\(image_width) text,\(display_name) text ,\(photo) text,\(first_caption) text,\(image_height) text ,\(file_type) text,\(second_name) text,\(video) text,\(multiple_images) text,\(x_cord) text,\(y_cord) text)"
                    
                    do {
                        try database.executeUpdate(createTableQuery, values: nil)
                        print("created table.")
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    func deleteTimeLine() -> Bool {
        var deleted = false
        
        if openDatabase() {
            let query = "delete from timeline_posts where \(tID) !=?"
            
            do {
                try database.executeUpdate(query, values: ["0"])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    



    
    func insertData(profile_image1 :String,post_id1:String , userid1 :String,second_userid1:String , post_like1 :String,location1 :String,first_display_name1 :String,post_points1 :String , first_user_profile_image1:String, caption1:String , date_time1:String, time_ago1:String , post_type1:String, image_width1:String , display_name1:String, photo1:String , first_caption1:String , image_height1:String, file_type1:String,second_name1:String,video1:String ,multiple:String ,xcord:String ,ycord:String)-> Bool {
        var success = true
        if openDatabase() {
           
            
            var query = ""
            query += "insert into timeline_posts (\(profile_image), \(post_id), \(userid),\(second_userid), \(post_like),\(location),\(first_display_name),\(post_points),\(first_user_profile_image),\(caption),\(date_time),\(time_ago),\(post_type),\(image_width),\(display_name),\(photo),\(first_caption),\(image_height),\(file_type),\(second_name),\(video)) values ( '\(profile_image1)', '\(post_id1)', '\(userid1)','\(second_userid1)', '\(post_like1)','\(location1)', '\(first_display_name1)','\(post_points1)','\(first_user_profile_image1)','\(caption1)','\(date_time1)' ,'\(time_ago1)', '\(post_type1)', '\(image_width)','\(display_name1)','\(photo1)','\(first_caption1)','\(image_height1)','\(file_type1)','\(second_name1)','\(video1)','\(multiple)','\(xcord)','\(ycord)');"
            if !database.executeStatements(query) {
                success = false
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
        else{
             success = false
        }
        database.close()
        
        return success
        
    }
   
    
//    func updatePractice(name :String,timeCount1:String , tdate :String,tnote:String , performance :String,day :String ,month :String,year :String,tDayno:String,time:Int, tweekYear:String)-> Bool {
//          var success = false
//        if openDatabase() {
//            let query = "update practice set \(timeCount)=?, \(tDate)=?,\(tNote)=?, \(tPerformance)=?, \(tDay)=?  , \(tMonth)=? ,\(tYear)=? ,\(tDayNo)=? ,\(timeDay)=? ,\(weekYear)=? where \(tname)=?"
//            
//            do {
//                try database.executeUpdate(query, values: [timeCount1, tdate, tnote,performance,day,month,year,tDayno,time,tweekYear,name])
//                success = true
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//            
//            database.close()
//        }
//          return success
//    }
    
   
    
    func loadTimeLine() -> [TimeLineModel]! {
        var timeLine: [TimeLineModel]!
        
        if openDatabase() {
            let query = "select * from timeline_posts where tID != ?"
            
            do {
                
                let results = try database.executeQuery(query, values: [""])
                
                
                while results.next() {
                    let p = TimeLineModel(tID: results.string(forColumn: tID),
                                          profile_image: results.string(forColumn: profile_image),
                                          post_id: results.string(forColumn: post_id),
                                          userid: results.string(forColumn: userid),
                                          second_userid: results.string(forColumn: second_userid),
                                          
                                          post_like: results.string(forColumn: post_like),
                                          location:results.string(forColumn: location),
                                          first_display_name:results.string(forColumn: first_display_name),
                                          post_points:results.string(forColumn: post_points),
                                          first_user_profile_image:results.string(forColumn: first_user_profile_image),
                                          
                                          caption:results.string(forColumn: caption),
                                          date_time:results.string(forColumn: date_time),
                                          time_ago:results.string(forColumn: time_ago),
                                          post_type:results.string(forColumn: post_type),
                                          image_width:results.string(forColumn: image_width),
                                          
                                          
                                          display_name:results.string(forColumn: display_name),
                                          photo:results.string(forColumn: photo),
                                          first_caption:results.string(forColumn: first_caption),
                                          image_height:results.string(forColumn: image_height),
                                          file_type:results.string(forColumn: file_type),
                                          second_name:results.string(forColumn: second_name),
                                          video:results.string(forColumn: video)
                        ,
                                          multiple_images:results.string(forColumn: multiple_images)
                        ,
                                          x_cord:results.string(forColumn: x_cord)
                        ,
                                          y_cord:results.string(forColumn: y_cord)
                        
                    )
                    
                    
                    
                    
                    if timeLine == nil {
                        timeLine = [TimeLineModel]()
                    }
                    
                    timeLine.append(p)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        if timeLine == nil {
            timeLine = [TimeLineModel]()
        }
        return timeLine
    }
    
    
    
    
    
    
    
    
}
