//
//  LocalJurorInfo.m
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import "LocalJurorInfo.h"

@implementation LocalJurorInfo

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (id) initWithJuror:(LocalJurorInfo *)juror
{
    if ( (self = [super init]) )
	{
        [self _init];
        
        self.tid = juror.tid;
        self.personality = juror.personality;
        self.token = juror.token;
        
        self.name = juror.name;
        
        self.gender = juror.gender;
        
        self.email = juror.email;
        
        self.occupation = juror.occupation;
        
        self.age = juror.age;
        self.rating = juror.rating;
        
        self.ethnicity = juror.ethnicity;
        
        self.symbol = juror.symbol;
        
        self.education = juror.education;
        self.politicalParty = juror.politicalParty;
        self.note = juror.note;
        
        self.preperemptory = juror.preperemptory;
        self.defence = juror.defence;
        self.cause = juror.cause;
        self.newVers = juror.newVers;
        
        self.avatarIndex = juror.avatarIndex;
        
        self.actionIndex = juror.actionIndex;
        
        self.overide = juror.overide;
	}
	
	return self;
}

- (void) _init
{
    self.tid = @"";
    self.personality = @"";
    self.token = @"";
    
    self.name = @"";
    
    self.gender = 0;
    
    self.email = @"";
    
    self.occupation = @"";
    
    self.age = 0;
    self.rating = 0;
    
    self.ethnicity = 0;
    
    self.symbol = @"";
    
    self.education = @"";
    self.politicalParty = @"";
    self.note = @"";
    
    self.preperemptory = 0;
    self.defence = 0;
    self.cause = 0;
    self.newVers = 0;
    
    self.avatarIndex = 0;
    
    self.actionIndex = -1;
    self.overide = @"";
}



@end
