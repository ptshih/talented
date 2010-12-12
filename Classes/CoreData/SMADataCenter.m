//
//  SMADataCenter.m
//  TalentPad
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SMADataCenter.h"
#import "Constants.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@interface SMADataCenter (Private)

@end

@implementation SMADataCenter

#pragma mark JSON Parsing Helpers
+ (id)objectFromData:(NSData *)data {
  id returnObject = nil;
  
  @try {
    returnObject = [[CJSONDeserializer deserializer] deserialize:data error:nil];
  }
  @catch (NSException * e) {
    DLog(@"Error parsing JSON from response: %@", e);
    returnObject = nil;
  }
  
  if (!returnObject) {
    returnObject = nil;
  }
  
  return returnObject;
}

+ (id)arrayFromData:(NSData *)data {
  NSArray *returnArray = nil;
  
  @try {
    returnArray = [[CJSONDeserializer deserializer] deserializeAsArray:data error:nil];
  }
  @catch (NSException * e) {
    DLog(@"Error parsing JSON from response: %@", e);
    returnArray = nil;
  }
  
  if (!returnArray) {
    returnArray = nil;
  }
  
  return returnArray;
}

+ (id)dictionaryFromData:(NSData *)data {
  NSArray *returnDictionary = nil;
  
  @try {
    returnDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
  }
  @catch (NSException * e) {
    DLog(@"Error parsing JSON from response: %@", e);
    returnDictionary = nil;
  }
  
  if (!returnDictionary) {
    returnDictionary = nil;
  }
  
  return returnDictionary;
}


@end
