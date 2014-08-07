//
//  KnowterNoteViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNoteDetailViewController.h"

@interface KnowterNoteDetailViewController ()

@end

@implementation KnowterNoteDetailViewController

#pragma mark - Properties

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
        
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(doneEditingNote)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(createNewNote)];
    }
}

#pragma mark - IBActions

- (IBAction)doneEditingNote {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)createNewNote {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
