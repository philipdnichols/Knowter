//
//  NoteHelper.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "NoteHelper.h"

@interface NoteHelper ()

@property (strong, nonatomic) NSDateFormatter *noteStorageDateFormatter;

@end

@implementation NoteHelper

#pragma mark - Singleton

+ (NoteHelper *)sharedNoteHelper
{
    static dispatch_once_t onceToken;
    __strong static NoteHelper *_sharedNoteHelper = nil;
    dispatch_once(&onceToken, ^{
        _sharedNoteHelper = [[NoteHelper alloc] init];
    });
    return _sharedNoteHelper;
}

#pragma mark - Properties

- (NSDateFormatter *)noteCellDateFormatter
{
    if (!_noteCellDateFormatter) {
        _noteCellDateFormatter = [[NSDateFormatter alloc] init];
        [_noteCellDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_noteCellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _noteCellDateFormatter;
}

- (NSDateFormatter *)noteDateFormatter
{
    if (!_noteDateFormatter) {
        _noteDateFormatter = [[NSDateFormatter alloc] init];
        [_noteDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [_noteDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _noteDateFormatter;
}

- (NSDateFormatter *)noteStorageDateFormatter
{
    if (!_noteStorageDateFormatter) {
        _noteStorageDateFormatter = [[NSDateFormatter alloc] init];
        [_noteStorageDateFormatter setDateStyle:NSDateFormatterFullStyle];
        [_noteStorageDateFormatter setTimeStyle:NSDateFormatterFullStyle];
    }
    return _noteStorageDateFormatter;
}

#pragma mark - Public

+ (NSArray *)loadNotes
{
    NSMutableArray *notes = [NSMutableArray array];
    
    NSArray *nsdNotes = [[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY];
    for (NSDictionary *nsdNote in nsdNotes) {
        Note *note = [[Note alloc] initWithContent:nsdNote[NOTES_CONTENT_KEY]
                               andModificationDate:[[NoteHelper sharedNoteHelper].noteStorageDateFormatter dateFromString:nsdNote[NOTES_MODIFICATION_DATE_KEY]]];
        [notes addObject:note];
    }
    
    return [notes copy];
}

+ (void)saveNote:(Note *)note
{
    NSMutableArray *notes = [[[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY] mutableCopy];
    if (!notes) {
        notes = [NSMutableArray array];
    }
    [notes insertObject:[NoteHelper dictionaryFromNote:note] atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:[notes copy]
                                              forKey:NOTES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteNote:(Note *)note
{
    NSMutableArray *notes = [[[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY] mutableCopy];
    NSUInteger index = [notes indexOfObjectPassingTest:^BOOL(NSDictionary *noteDictionary, NSUInteger idx, BOOL *stop) {
        NSDate *modificationDate = [[NoteHelper sharedNoteHelper].noteStorageDateFormatter dateFromString:noteDictionary[NOTES_MODIFICATION_DATE_KEY]];
        if ([modificationDate isEqual:note.modificationDate]) {
            return YES;
        }
        return NO;
    }];
    
    [notes removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults] setObject:[notes copy]
                                              forKey:NOTES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)reorderNoteFrom:(int)fromIndex to:(int)toIndex
{
    NSMutableArray *notes = [[[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY] mutableCopy];
    
    id note = [notes objectAtIndex:fromIndex];
    [notes removeObjectAtIndex:fromIndex];
    [notes insertObject:note atIndex:toIndex];
    
    [[NSUserDefaults standardUserDefaults] setObject:[notes copy]
                                              forKey:NOTES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private

+ (NSDictionary *)dictionaryFromNote:(Note *)note
{
    NSDictionary *noteDictionary = @{
                                     NOTES_CONTENT_KEY : note.content,
                                     NOTES_MODIFICATION_DATE_KEY : [[NoteHelper sharedNoteHelper].noteStorageDateFormatter stringFromDate:note.modificationDate]
                                     };
    
    return noteDictionary;
}

@end
