//
//  Note.m
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "Note.h"

@implementation Note

#pragma mark - Properties

- (NSString *)title {
    // Remove newlines from the beginning of the text to avoid a blank title
    NSMutableArray *components = [[self.content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)obj;
            if (![str length]) {
                [components removeObject:obj];
            }
        }
    }];
    return [self.content length] ? components[0] : @"Note";
}

#pragma mark - Initializers

- (instancetype)initWithContent:(NSString *)content
            andModificationDate:(NSDate *)modificationDate {
    self = [super init];
    if (self) {
        _content = content;
        _modificationDate = modificationDate;
    }
    return self;
}

@end
