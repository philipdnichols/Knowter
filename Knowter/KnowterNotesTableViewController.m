//
//  KnowterNotesTableViewController.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "KnowterNotesTableViewController.h"
#import "KnowterNoteDetailViewController.h"
#import "NoteHelper.h"

@interface KnowterNotesTableViewController ()

@property (strong, nonatomic) NSMutableArray *notes; // of Note

@end

@implementation KnowterNotesTableViewController

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
    
    [self loadNotes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadNotes];
}

- (void)loadNotes {
    self.notes = [[NoteHelper loadNotes] mutableCopy];
    
    if ([self.notes count]) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)newNoteButtonTouch
{
    id detail = self.splitViewController.viewControllers[1];
    if (detail) {
        if ([detail isKindOfClass:[UINavigationController class]]) {
            detail = [((UINavigationController *)detail).viewControllers firstObject];
            if ([detail isKindOfClass:[KnowterNoteDetailViewController class]]) {
                [self prepareNoteDetailViewController:detail
                                             withNote:nil
                                              editing:YES];
            }
        }
    } else {
        KnowterNoteDetailViewController *noteDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KnowterNoteDetailViewController"];
        [self prepareNoteDetailViewController:noteDetailViewController
                                     withNote:nil
                                      editing:YES];
        
        UINavigationController *noteDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:noteDetailViewController];
        noteDetailNavigationController.navigationBar.translucent = NO;
        noteDetailNavigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        [self presentViewController:noteDetailNavigationController
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NoteCellIdentifier = @"Note Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier
                                                            forIndexPath:indexPath];
    
    Note *note = self.notes[indexPath.row];
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [[NoteHelper sharedNoteHelper].noteCellDateFormatter stringFromDate:note.modificationDate];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = self.notes[indexPath.row];
        [self.notes removeObjectAtIndex:indexPath.row];
        [NoteHelper deleteNote:note];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (![self.notes count]) {
            [self setEditing:NO animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [NoteHelper reorderNoteFrom:fromIndexPath.row to:toIndexPath.row];
    [self loadNotes];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
        if ([detail isKindOfClass:[KnowterNoteDetailViewController class]]) {
            [self prepareNoteDetailViewController:detail
                                         withNote:self.notes[indexPath.row]
                                          editing:NO];
        }
    }
}

#pragma mark - UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (!editing) {
        if (![self.notes count]) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString *DisplayNoteSegueIdentifier = @"Edit Note";
    
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if ([segue.identifier isEqualToString:DisplayNoteSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[KnowterNoteDetailViewController class]]) {
            [self prepareNoteDetailViewController:segue.destinationViewController
                                         withNote:indexPath ? self.notes[indexPath.row] : nil
                                          editing:NO];
        }
    }
}

- (void)prepareNoteDetailViewController:(KnowterNoteDetailViewController *)viewController withNote:(Note *)note editing:(BOOL)editing
{
    viewController.editing = editing;
    viewController.note = note;
}

@end
