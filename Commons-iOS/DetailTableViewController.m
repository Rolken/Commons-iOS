//
//  DetailTableViewController.m
//  Commons-iOS
//
//  Created by Brion on 1/29/13.
//  Copyright (c) 2013 Wikimedia. All rights reserved.
//

#import "DetailTableViewController.h"
#import "CommonsApp.h"
#import "WebViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Can't seem to set the left/top cap sizes in IB
    [self.deleteButton setBackgroundImage:[[UIImage imageNamed:@"redbutton.png"]
         stretchableImageWithLeftCapWidth:8.0f
                             topCapHeight:0.0f]
                                 forState:UIControlStateNormal];

    // Load up the selected record
    CommonsApp *app = CommonsApp.singleton;
    FileUpload *record = self.selectedRecord;
    if (record != nil) {
        self.titleTextField.text = record.title;
        self.descriptionTextView.text = record.desc;
        if (record.complete.boolValue) {
            // Completed upload...
            self.titleTextField.enabled = NO;
            self.descriptionTextView.editable = NO;
            self.deleteButton.hidden = YES;
            self.openPageButton.hidden = NO;

            // Fetch medium thumbnail from the interwebs
            CGFloat density = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(284.0f * density, 212.0f * density);
            
            // Start by showing the locally stored thumbnail
            if (record.thumbnailFile != nil) {
                self.imagePreview.image = [app loadThumbnail:record.thumbnailFile];
            }
            self.imageSpinner.hidden = NO;
            [app fetchWikiImage:record.title size:size onCompletion:^(UIImage *image) {
                self.imageSpinner.hidden = YES;
                self.imagePreview.image = image;
            }];
        } else {
            // Locally queued file...
            self.titleTextField.enabled = YES;
            self.descriptionTextView.editable = YES;
            self.deleteButton.hidden = NO;
            self.openPageButton.hidden = YES;

            // Use the pre-uploaded file as the medium thumbnail
            self.imagePreview.image = [app loadImage:record.localFile];
            if (self.imagePreview.image == nil) {
                // Can't read that file format natively; use our thumbnail icon
                self.imagePreview.image = [app loadThumbnail:record.thumbnailFile];
            }
            self.imageSpinner.hidden = YES;
        }
    } else {
        NSLog(@"This isn't right, have no selected record in detail view");
    }

    // Set delegates so we know when fields change...
    self.titleTextField.delegate = self;
    self.descriptionTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenPageSegue"]) {
        if (self.selectedRecord) {
            WebViewController *view = [segue destinationViewController];
            NSString *pageTitle = [@"File:" stringByAppendingString:self.selectedRecord.title];
            view.targetURL = [CommonsApp.singleton URLForWikiPage:pageTitle];
        }
    }
}

- (void)viewDidUnload {
    [self setImagePreview:nil];
    [self setTitleTextField:nil];
    [self setDescriptionTextView:nil];
    [self setSelectedRecord:nil];
    [self setDeleteButton:nil];
    [self setImageSpinner:nil];
    [self setOpenPageButton:nil];
    [super viewDidUnload];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CommonsApp *app = CommonsApp.singleton;
    FileUpload *record = self.selectedRecord;
    NSLog(@"setting title: %@", self.titleTextField.text);
    record.title = self.titleTextField.text;
    [app saveData];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CommonsApp *app = CommonsApp.singleton;
    FileUpload *record = self.selectedRecord;
    NSLog(@"setting desc: %@", self.descriptionTextView.text);
    record.desc = self.descriptionTextView.text;
    [app saveData];
}

- (IBAction)deleteButtonPushed:(id)sender {
    CommonsApp *app = CommonsApp.singleton;
    [app deleteUploadRecord:self.selectedRecord];
    self.selectedRecord = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openPageButtonPushed:(id)sender {
}
@end
