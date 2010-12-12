//
//  TalentViewController.h
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalentButtonViewController.h"

@interface TalentViewController : UIViewController <TalentButtonDelegate> {
  IBOutlet UIView *_summaryView;
  IBOutlet UIView *_talentView;
  IBOutlet UIView *_glyphView;
  NSString *_selectedClass;
  NSMutableArray *_talentButtonArray;
}

@property (nonatomic, retain) NSString *selectedClass;
@property (nonatomic, retain) NSMutableArray *talentButtonArray;

@end
