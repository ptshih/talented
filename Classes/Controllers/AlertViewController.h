//
//  AlertViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/21/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertDelegate <NSObject>
@optional
- (void)alertCancelled;
- (void)alertSavedWithName:(NSString *)saveName;
@end

@interface AlertViewController : UIViewController {
//  IBOutlet UIImageView *_saveBackground;
  IBOutlet UILabel *_saveLabel;
  IBOutlet UITextField *_textField;
  IBOutlet UIButton *_cancelButton;
  IBOutlet UIButton *_saveButton;
  
  id <AlertDelegate> _delegate;
}

@property (nonatomic, assign) id <AlertDelegate> delegate;

- (IBAction)cancel;
- (IBAction)save;
- (IBAction)textFieldDidUpdate:(id)sender;

@end
