//
//  TalentedAppDelegate.h
//  Talented
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherViewController;
@class CharacterClass;

@interface TalentedAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  LauncherViewController *_launcherViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LauncherViewController *launcherViewController;

- (void)talentDataTestForClass:(NSString *)classString;
- (void)loadGlyphsForCharacterClass:(CharacterClass *)characterClass;
- (NSString *)glyphKeyPathForCharacterClass:(CharacterClass *)characterClass;
- (void)migrateSaves;
- (NSArray *)fetchAllSavesAsDictionary;
- (void)insertAllSaves:(NSArray *)saves;

@end

