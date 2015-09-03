//
//  QuestionInfo.m
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import "QuestionInfo.h"

@implementation QuestionInfo

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (id) init:(NSString *)question
{
    if ( (self = [super init]) )
	{
        [self _init];
        
        self.question = question;
	}
	
	return self;
}

- (id) initWithQuestion:(QuestionInfo *)question
{
    if ( (self = [super init]) )
	{
        [self _init];
        
        self.qid = question.qid;
        
        self.groupId = question.groupId;
        
        self.title = question.title;
        self.question = question.question;
        self.symbol = question.symbol;
        self.sumQuestion = question.sumQuestion;
        
        self.answer = question.answer;
        
        self.responsePositive = question.responsePositive;
        self.responseNagative = question.responseNagative;
        
        self.style = question.style;
        self.weight = question.weight;
	}
	
	return self;
}

- (void) _init
{
    self.groupId = -1;
    
    self.qid = [[NSDate date] timeIntervalSince1970];
    self.title = @"";
    self.question = @"";
    self.symbol = @"";
    self.sumQuestion = @"";
    
    self.answer = @"";
    
    self.responsePositive = -1;
    self.responseNagative = -1;
    
    self.style = 0;
    self.weight = 0;
}

@end
