//
//  TalentedAppDelegate.h
//  Talented
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherViewController;

@interface TalentedAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  LauncherViewController *_launcherViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LauncherViewController *launcherViewController;

- (void)talentDataTestForClass:(NSString *)classString;

@end

