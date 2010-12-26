//
//  CalculatorViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TreeViewController.h"
#import "SummaryViewController.h"
#import "SaveViewController.h"
#import "AlertViewController.h"

typedef enum {
  CalculatorStateEnabled = 0,
  CalculatorStateAllEnabled = 1,
  CalculatorStateFinished = 2
} CalculatorState;

@class TooltipViewController;

@interface CalculatorViewController : UIViewController <TreeDelegate, SummaryDelegate, SaveDelegate, AlertDelegate, MFMailComposeViewControllerDelegate> {
  IBOutlet UIView *_talentTreeView;
  IBOutlet UIView *_summaryView;
  IBOutlet UIButton *_swapButton;
  IBOutlet UIButton *_resetButton;
  
  // Navigation
  IBOutlet UIButton *_backButton;
  IBOutlet UIButton *_loadButton;
  IBOutlet UIButton *_saveButton;
  IBOutlet UIButton *_exportButton;
  
  // Header Stuff
  IBOutlet UIImageView *_leftIcon;
  IBOutlet UIImageView *_middleIcon;
  IBOutlet UIImageView *_rightIcon;
  IBOutlet UILabel *_leftLabel;
  IBOutlet UILabel *_middleLabel;
  IBOutlet UILabel *_rightLabel;
  IBOutlet UIImageView *_leftBorder;
  IBOutlet UIImageView *_middleBorder;
  IBOutlet UIImageView *_rightBorder;
  IBOutlet UILabel *_leftPoints;
  IBOutlet UILabel *_middlePoints;
  IBOutlet UILabel *_rightPoints;
  IBOutlet UILabel *_requiredLevel;
  IBOutlet UILabel *_pointsLeft;
  IBOutlet UILabel *_pointsSpent;
  
  TooltipViewController *_tooltipViewController;

  NSArray *_treeArray;
  NSMutableArray *_treeViewArray;
  NSMutableArray *_summaryViewArray;
  NSInteger _characterClassId;
  NSInteger _specTreeNo;
  NSInteger _totalPoints;
  NSInteger _state;
  NSInteger _newSpecTreeNo;
  
  UIPopoverController *_alertPopoverController;
  SaveViewController *_saveViewController;
}

@property (nonatomic, retain) TooltipViewController *tooltipViewController;
@property (nonatomic, retain) NSArray *treeArray;
@property (nonatomic, retain) NSMutableArray *treeViewArray;
@property (nonatomic, retain) NSMutableArray *summaryViewArray;
@property (nonatomic, assign) NSInteger characterClassId;
@property (nonatomic, assign) NSInteger specTreeNo;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger state;

// Nav actions
- (IBAction)back;
- (IBAction)save;
- (IBAction)load;
- (IBAction)export;

- (IBAction)resetLeft;
- (IBAction)resetMiddle;
- (IBAction)resetRight;
- (IBAction)resetAll;
- (IBAction)swapViews;
- (void)hideTooltip;

- (void)loadWithSaveString:(NSString *)saveString andSpecTree:(NSInteger)specTree;

@end
