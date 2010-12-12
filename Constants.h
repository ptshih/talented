/*
 *  Constants.h
 *  TalentPad
 *
 *  Created by Peter Shih on 11/25/10.
 *  Copyright 2010 Seven Minute Apps. All rights reserved.
 *
 */

#define WOW_ASSETS_URL @"http://us.battle.net/wow-assets/static/images/icons/56/"

#define WOW_ICON_URL(icon) [NSString stringWithFormat:@"%@%@.jpg", WOW_ASSETS_URL, icon]

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