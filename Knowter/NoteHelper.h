//
//  NoteHelper.h
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

#define NOTES_KEY @"KNOWTER_NOTES_KEY"
#define NOTES_CONTENT_KEY @"content"
#define NOTES_MODIFICATION_DATE_KEY @"modificationDate"

@interface NoteHelper : NSObject

@property (strong, nonatomic) NSDateFormatter *noteCellDateFormatter;
@property (strong, nonatomic) NSDateFormatter *noteDateFormatter;

+ (NoteHelper *)sharedNoteHelper;

+ (NSArray *)loadNotes;
+ (void)saveNote:(Note *)note;
+ (void)deleteNote:(Note *)note;
+ (void)reorderNoteFrom:(int)fromIndex to:(int)toIndex;

@end
