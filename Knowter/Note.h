//
//  Note.h
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *modificationDate;
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithContent:(NSString *)content
            andModificationDate:(NSDate *)modificationDate;

@end
