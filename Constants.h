/*
 *  Constants.h
 *  Talented
 *
 *  Created by Peter Shih on 11/25/10.
 *  Copyright 2010 Seven Minute Apps. All rights reserved.
 *
 */

//#define REMOTE_TALENT_IMAGES // this downloads and uses icons from wowarmory
//#define DOWNLOAD_TALENT_IMAGES // if this is defined, we will save the icons to disk

//#define FORCE_MIGRATION

#define PATCH_VERSION 4.0.6

#define LANGUAGES [NSArray arrayWithObjects:@"en", @"fr", @"de", @"es", @"ru", @"ko", nil]
#define USER_LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]

#define WOW_ASSETS_URL @"http://us.battle.net/wow-assets/static/images/icons/56/"

#define WOW_ICON_URL(icon) [NSString stringWithFormat:@"%@%@.jpg", WOW_ASSETS_URL, icon]
#define WOW_ICON_LOCAL(icon) [NSString stringWithFormat:@"%@.jpg", icon]

#define LABEL_COLOR_GREEN RGBCOLOR(25.0,182.0,0.0)
#define LABEL_COLOR_YELLOW RGBCOLOR(255.0,210.0,0.0)

#define TOOLTIP_COLOR_RED RGBCOLOR(255.0,51.0,51.0)

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// App Delegate Macro
#define APP_DELEGATE ((FacemashAppDelegate *)[[UIApplication sharedApplication] delegate])

// Logging Macros
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

//#define VERBOSE_DEBUG
#ifdef VERBOSE_DEBUG
#define VLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// Detect Device Type
//static BOOL isDeviceIPad() {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
//  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//    return YES; 
//  }
//#endif
//  return NO;
//}