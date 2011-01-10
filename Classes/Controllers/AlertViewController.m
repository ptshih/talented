    //
//  AlertViewController.m
//  Talented
//
//  Created by Peter Shih on 12/21/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "AlertViewController.h"

#define TOOLTIP_CAP 15

static UIImage *_redButtonImage = nil;

@implementation AlertViewController

@synthesize delegate = _delegate;

+ (void)initialize {
  _redButtonImage = [[[UIImage imageNamed:@"red_button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:6] retain];
}

- (void)viewDidLoad {
  [super viewDidLoad];
//  _saveBackground.image = [[UIImage imageNamed:@"tooltip_bg.png"] stretchableImageWithLeftCapWidth:TOOLTIP_CAP topCapHeight:TOOLTIP_CAP];
  [_cancelButton setBackgroundImage:_redButtonImage forState:UIControlStateNormal];
  [_saveButton setBackgroundImage:_redButtonImage forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_textField becomeFirstResponder];
  _saveButton.enabled = NO;
}

- (IBAction)cancel {
  if (self.delegate) {
    [self.delegate alertCancelled];
  }
}

- (IBAction)save {
  if (self.delegate) {
    [self.delegate alertSavedWithName:_textField.text];
  }
}

- (IBAction)textFieldDidUpdate:(id)sender {
  UITextField *textField = (UITextField *)sender;
  
  NSInteger numChars = textField.text.length;
  if (numChars == 0) {
    _saveButton.enabled = NO;
  } else {
    _saveButton.enabled = YES;
  }

}
  
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (_saveButton.enabled) {
    [self save];
  }
  return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
  [super viewDidUnload];
}


- (void)dealloc {
//  if (_saveBackground) [_saveBackground release];
  if (_saveLabel) [_saveLabel release];
  if (_textField) [_textField release];
  if (_cancelButton) [_cancelButton release];
  if (_saveButton) [_saveButton release];
  [super dealloc];
}


@end
