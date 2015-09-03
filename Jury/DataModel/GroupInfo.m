//
//  GroupInfo.m
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import "GroupInfo.h"

@implementation GroupInfo

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (void) _init
{
    self.groupId = 0;
    self.groupTitle = @"";
    self.groupDesciption = @"";
}

@end
