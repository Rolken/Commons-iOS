//
//  DetailTableViewController.h
//  Commons-iOS
//
//  Created by Brion on 1/29/13.
//  Copyright (c) 2013 Wikimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileUpload.h"

@interface DetailTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *openPageButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageSpinner;

@property (strong, nonatomic) FileUpload *selectedRecord;

- (IBAction)deleteButtonPushed:(id)sender;
- (IBAction)openPageButtonPushed:(id)sender;

@end
