//
//  VideoFilter.m
//  DTLiving
//
//  Created by Dan Jiang on 2020/3/17.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#import "VideoFilter.h"

@interface VideoFilter ()

@property (nonatomic, copy) NSString *name;

@end

@implementation VideoFilter

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end
