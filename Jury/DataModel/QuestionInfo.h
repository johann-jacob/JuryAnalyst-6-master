//
//  QuestionInfo.h
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionInfo : NSObject

@property (nonatomic, assign) NSInteger qid;

@property (nonatomic, assign) NSInteger groupId;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) NSString *sumQuestion;

@property (nonatomic, retain) NSString *answer;

@property (nonatomic, assign) int responsePositive;
@property (nonatomic, assign) int responseNagative;

@property (nonatomic, assign) int style;
@property (nonatomic, assign) int weight;

- (id) init:(NSString *)question;
- (id) initWithQuestion:(QuestionInfo *)question;

@end
