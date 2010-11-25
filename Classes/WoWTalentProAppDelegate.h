//
//  WoWTalentProAppDelegate.h
//  WoWTalentPro
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherViewController;

@interface WoWTalentProAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *_navigationController;
  LauncherViewController *_launcherViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) LauncherViewController *launcherViewController;

@end

