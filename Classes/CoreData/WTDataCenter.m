//
//  WTDataCenter.m
//  WoWTalentPro
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "WTDataCenter.h"
#import "Constants.h"
#import "JSON.h"

static SBJsonParser *_parser = nil;

@interface WTDataCenter (Private)

@end

@implementation WTDataCenter

+ (void)load {
  _parser = [[SBJsonParser alloc] init];
}

#pragma mark JSON Parsing Helpers
+ (id)objectFromData:(NSData *)data {
  id returnObject = nil;
  
  @try {
    returnObject = [_parser objectWithString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]];
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

@end
