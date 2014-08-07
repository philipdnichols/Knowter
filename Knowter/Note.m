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
    return [self.content length] ? [self.content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]][0] : @"";
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
