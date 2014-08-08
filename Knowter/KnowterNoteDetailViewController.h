//
//  KnowterNoteViewController.h
//  Knowter
//
//  Created by Philip Nichols on 8/6/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol KnowterNoteDetailDelegate <NSObject>

- (void)saveNote:(Note *)note;

@end

@interface KnowterNoteDetailViewController : UIViewController

@property (weak, nonatomic) id <KnowterNoteDetailDelegate> delegate;

@property (strong, nonatomic) Note *note;
@property (nonatomic) BOOL editing;

@end
