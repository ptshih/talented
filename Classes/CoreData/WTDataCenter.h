//
//  WTDataCenter.h
//  WoWTalentPro
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 Static parent class that wraps data management, including parsing and core data operations.
 */

@interface WTDataCenter : NSObject {

}

#pragma JSON parsing helper methods

/**
 Returns a parsed autoreleased object from JSON NSData. If the parsing fails for whatever reason, an empty array
 will be returned.
 
 @param data The NSData that you want parsed into an object (array or dictionary) (this should be NSData with a JSON format)
 */
+ (id)objectFromData:(NSData *)data;




@end
