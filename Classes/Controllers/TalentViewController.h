//
//  TalentViewController.h
//  WoWTalentPro
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TalentViewController : UIViewController {
  IBOutlet UIScrollView *_scrollView;
  NSString *_selectedClass;
  NSMutableArray *_talentButtonArray;
}

@property (nonatomic, retain) NSString *selectedClass;
@property (nonatomic, retain) NSMutableArray *talentButtonArray;

@end
