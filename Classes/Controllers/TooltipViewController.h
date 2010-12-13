//
//  TooltipViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoTextView;
@class TreeViewController;
@class TalentViewController;

@interface TooltipViewController : UIViewController {
  TreeViewController *_treeView;
	TalentViewController *_talentView;
  
	// IB Outlets
	IBOutlet InfoTextView *_tooltip;
	IBOutlet UIImageView *bgImage;
	IBOutlet UIImageView *bgTop;
	IBOutlet UIImageView *bgBottom;
	IBOutlet UIButton *addButton;
	IBOutlet UIButton *delButton;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *rankLabel;
	IBOutlet UILabel *reqsLabel;
	IBOutlet UILabel *req2Label;
	IBOutlet UILabel *TLLabel;
	IBOutlet UILabel *TRLabel;
	IBOutlet UILabel *BLLabel;
	IBOutlet UILabel *BRLabel;
}

@property (nonatomic, assign) TreeViewController *treeView;
@property (nonatomic, assign) TalentViewController *talentView;


@property (assign) UIImageView *bgImage;
@property (assign) UIImageView *bgTop;
@property (assign) UIImageView *bgBottom;
@property (assign) UIButton *addButton;
@property (assign) UIButton *delButton;

@property (assign) UILabel *nameLabel;
@property (assign) UILabel *rankLabel;
@property (assign) UILabel *reqsLabel;
@property (assign) UILabel *req2Label;
@property (assign) UILabel *TLLabel;
@property (assign) UILabel *TRLabel;
@property (assign) UILabel *BLLabel;
@property (assign) UILabel *BRLabel;


- (void)setInfo;
- (void)setTooltip;
- (void)updateInfo;
- (void)updateLabels;
- (void)updateDesc;
- (IBAction)addPoint:(id)sender;
- (IBAction)removePoint:(id)sender;

@end
