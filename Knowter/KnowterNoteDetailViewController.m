//
//  KnowterNoteViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNoteDetailViewController.h"
#import "NoteHelper.h"

@interface KnowterNoteDetailViewController () <UISplitViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) NSTimer *modificationDateLabelUpdateTimer;

@property (strong, nonatomic) UIAlertView *cancelAlert;
@property (strong, nonatomic) UIAlertView *doneAlert;

@property (weak, nonatomic) IBOutlet UILabel *modificationDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation KnowterNoteDetailViewController

#pragma mark - Properties

- (void)setNote:(Note *)note {
    _note = note;
    
    if (!_note) {
        _note = [[Note alloc] initWithContent:@""
                          andModificationDate:[NSDate date]];
    }
    
    [self updateUI];
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    [self updateUI];
}

- (UIAlertView *)cancelAlert {
    if (!_cancelAlert) {
        _cancelAlert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                  message:@"Are you sure you want to discard this note?"
                                                 delegate:self
                                        cancelButtonTitle:@"No"
                                        otherButtonTitles:@"Yes", nil];
    }
    return _cancelAlert;
}

- (UIAlertView *)doneAlert {
    if (!_doneAlert) {
        _doneAlert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                message:@"Are you sure you want to save an empty note?"
                                               delegate:self
                                      cancelButtonTitle:@"No"
                                      otherButtonTitles:@"Yes", nil];
    }
    return _doneAlert;
}

#pragma mark - Initializers

- (void)setup
{
    // Custom setup that must happen before viewDidLoad
    
    self.splitViewController.delegate = self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iPad split view means that we should start edit mode when the view loads
    if (self.splitViewController) {
        id master = self.splitViewController.viewControllers[0];
        if ([master isKindOfClass:[UINavigationController class]]) {
            master = [((UINavigationController *)master).viewControllers firstObject];
        }
        self.delegate = master;
        self.note = nil;
        self.editing = YES;
    }
    
    self.modificationDateLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                             target:self
                                                                           selector:@selector(updateModificationDateLabel:)
                                                                           userInfo:nil
                                                                            repeats:YES];
    
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // If we are editing, make sure the keyboard pops up on the context text view after the view appears
    if (self.editing) {
        [self.contentTextView becomeFirstResponder];
    }
}

- (void)updateModificationDateLabel:(NSTimer *)timer {
    if (self.editing) {
        dispatch_queue_t q = dispatch_queue_create("update modification date label", NULL);
        dispatch_async(q, ^{
            NSString *newDate =[[NoteHelper sharedNoteHelper].noteDateFormatter stringFromDate:[NSDate date]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.modificationDateLabel.text = newDate;
            });
        });
    }
}

- (void)updateUI
{
    if (self.editing) {
        if (self.splitViewController) {
            // iPad split view editing
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                      style:UIBarButtonItemStyleDone
                                                                                     target:self
                                                                                     action:@selector(doneEditingNote)];
            [self.contentTextView becomeFirstResponder];
        } else {
            // non-iPad modal editing
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(cancelEditingNote)];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                      style:UIBarButtonItemStyleDone
                                                                                     target:self
                                                                                     action:@selector(doneEditingNote)];
        }
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.splitViewController) {
        // Dismiss the master popover whenever the detail view is updated (master table is selected or a new note is created from the master table)
        [self.popover dismissPopoverAnimated:YES];
    }
    
    self.contentTextView.editable = self.editing;
    
    self.modificationDateLabel.text = [[NoteHelper sharedNoteHelper].noteDateFormatter stringFromDate:self.note.modificationDate];
    self.contentTextView.text = self.note.content;
}

#pragma mark - IBActions

- (IBAction)cancelEditingNote
{
    if ([self.contentTextView.text length]) {
        // Show a confirmation dialog if a note with text contents in it is cancelled
        [self.cancelAlert show];
    } else {
        [self cancelEditing];
    }
}

- (void)cancelEditing {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)doneEditingNote
{
    if (![self.contentTextView.text length]) {
        [self.doneAlert show];
    } else {
        [self doneEditing];
    }
}

- (void)doneEditing {
    self.note.content = self.contentTextView.text;
    self.note.modificationDate = [NSDate date];
    
    // The delegate will handle the save
    [self.delegate saveNote:self.note];
    
    if (self.splitViewController) {
        self.editing = NO;
    } else {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    self.popover = pc;
    
    UIViewController *master = aViewController;
    if ([master isKindOfClass:[UINavigationController class]]) {
        master = ((UINavigationController *)master).topViewController;
    }
    
    barButtonItem.title = master.navigationItem.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.popover = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.cancelAlert) {
        switch (buttonIndex) {
            case 1:
                [self cancelEditing];
                break;
                
            default:
                break;
        }
    } else if (alertView == self.doneAlert) {
        switch (buttonIndex) {
            case 1:
                [self doneEditing];
                break;
                
            default:
                break;
        }
    }
}

@end
