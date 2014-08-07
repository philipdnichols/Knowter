//
//  KnowterNoteViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNoteDetailViewController.h"
#import "NoteHelper.h"

@interface KnowterNoteDetailViewController () <UISplitViewControllerDelegate>

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
        
        
        if (self.editing) {
            [self.contentTextView becomeFirstResponder];
        }
    }
    
    self.modificationDateLabel.text = [[NoteHelper sharedNoteHelper].noteDateFormatter stringFromDate:_note.modificationDate];
    self.contentTextView.text = _note.content;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    if (!self.splitViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancelEditingNote)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(doneEditingNote)];
    } else if (_editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(doneEditingNote)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.contentTextView.editable = _editing;
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
    
    self.note = nil;
    self.editing = YES;
}

#pragma mark - IBActions

- (IBAction)cancelEditingNote
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)doneEditingNote
{
    self.editing = NO;
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.note.content = self.contentTextView.text;
    self.note.modificationDate = [NSDate date];
    [NoteHelper saveNote:self.note];
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
    self.navigationItem.leftBarButtonItem = nil;
}

@end
