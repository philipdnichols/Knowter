//
//  KnowterNoteViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNoteDetailViewController.h"
#import "NoteHelper.h"

@interface KnowterNoteDetailViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UILabel *modificationDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation KnowterNoteDetailViewController

#pragma mark - Properties

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

#pragma mark - Initializers

- (void)setup
{
    // Custom setup that must happen before viewDidLoad
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
    
    if (self.note) {
        self.modificationDateLabel.text = self.note.modificationDate;
        self.contentTextView.text = self.note.content;
        self.contentTextView.editable = NO;
    } else {
        self.modificationDateLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
        self.contentTextView.text = @"";
        [self.contentTextView becomeFirstResponder];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancelEditingNote)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(doneEditingNote)];
    }
}

#pragma mark - IBActions

- (IBAction)cancelEditingNote {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)doneEditingNote {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    Note *note = [[Note alloc] initWithContent:self.contentTextView.text
                           andModificationDate:self.modificationDateLabel.text];
    [NoteHelper saveNote:note];
}

@end
