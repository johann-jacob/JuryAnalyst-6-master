//
//  CaseInfo.m
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import "CaseInfo.h"

@implementation CaseInfo

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
    self.name = @"";
    
    self.number = @"";
    self.location = @"";
    self.courthouse = @"";
    
    self.numberOfJurors = 0;
    
    self.rows = 5;
    self.columns = 8;
    
    self.avatars = YES;
    self.commonVoirDire = YES;
    self.civil = YES;
}

@end
