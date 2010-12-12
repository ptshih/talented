//
//  WTDataCenter.h
//  TalentPad
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
+ (id)objectFromData:(NSData *)data;
+ (id)arrayFromData:(NSData *)data;
+ (id)dictionaryFromData:(NSData *)data;

@end
