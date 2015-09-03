//
//  SampleQuestions.h
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SampleQuestions : NSObject
{
    
}

@property (nonatomic, retain) NSMutableArray *aryQuestionaires;

+ (SampleQuestions *)shareSampleQuestions;
+ (void)releaseSampleQuestions;

- (void) addQuestionaire:(NSString *)name;
- (void) saveCurrentQuestionsToQuestionaire:(NSString *)name description:(NSString *)description;

@end
