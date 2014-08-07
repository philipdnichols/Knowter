//
//  NoteHelper.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "NoteHelper.h"

@implementation NoteHelper

#pragma mark - Public

+ (NSArray *)loadNotes {
    NSMutableArray *notes = [NSMutableArray array];
    
    NSArray *nsdNotes = [[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY];
    for (NSDictionary *nsdNote in nsdNotes) {
        Note *note = [[Note alloc] initWithContent:nsdNote[NOTES_CONTENT_KEY]
                               andModificationDate:nsdNote[NOTES_MODIFICATION_DATE_KEY]];
        [notes addObject:note];
    }
    
    return [notes copy];
}

+ (void)saveNote:(Note *)note {
    NSMutableArray *notes = [[[NSUserDefaults standardUserDefaults] arrayForKey:NOTES_KEY] mutableCopy];
    if (!notes) {
        notes = [NSMutableArray array];
    }
    [notes addObject:[self dictionaryFromNote:note]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[notes copy]
                                              forKey:NOTES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private

+ (NSDictionary *)dictionaryFromNote:(Note *)note {
    NSDictionary *noteDictionary = @{
                                     NOTES_CONTENT_KEY : note.content,
                                     NOTES_MODIFICATION_DATE_KEY : note.modificationDate
                                     };
    
    return noteDictionary;
}

@end
