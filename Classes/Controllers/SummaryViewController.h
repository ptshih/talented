//
//  SummaryViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/13/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalentTree;

@protocol SummaryDelegate <NSObject>
@required
- (void)specTreeSelected:(NSInteger)treeNo;
@end

@interface SummaryViewController : UIViewController {
  IBOutlet UIButton *_redButton;
  
  TalentTree *_talentTree;
  id <SummaryDelegate> _delegate;
}

@property (nonatomic, assign) TalentTree *talentTree;
@property (nonatomic, assign) id <SummaryDelegate> delegate;

- (IBAction)selectSpecTree;

@end
