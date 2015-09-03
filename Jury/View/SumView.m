//
//  SumView.m
//  JuryAnalyst
//
//  Created by Jake D on 7/30/15.
//  Copyright (c) 2015 Alioth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SumView.h"
#import "DataManager.h"
#import "QuestionInfo.h"
#import "GroupInfo.h"
#import "LocalJurorInfo.h"

@interface SumView()
{
}
@property (nonatomic, retain) LocalJurorInfo *juror;
@property (nonatomic, retain) QuestionInfo *theQuestion;
@property (nonatomic, retain) UIScrollView *mainScroll;
@property (nonatomic, retain) UIView    *mainView;
@property (weak, nonatomic) IBOutlet UIButton *close;
@end

@implementation SumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (IBAction)closeView:(id)sender {
    [self.delegate closeSummary:self];
}

-(void) _initWithJuror:(LocalJurorInfo *)juror{
    self.juror = [[LocalJurorInfo alloc] initWithJuror:juror];
    
//    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
//    
//    [yourLabel setTextColor:[UIColor blackColor]];
//    [yourLabel setBackgroundColor:[UIColor clearColor]];
//    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//    [yourLabel setText:@"yoyoyoy"];
//    [self addSubview:yourLabel];
    _mainScroll = [[UIScrollView alloc] initWithFrame:self.frame];
    _mainView = [[UIView alloc] initWithFrame:self.frame];
    
    
    int xVal = 0;
    int curGroup = 0;
    int addedY = 10;
    float maxWidth = 350.0;
    float selfWidth = 350.0;
    for(int i = 0; i < [[DataManager shareDataManager].aryLocalQuestions count]; i++){
        
        self.theQuestion = [[DataManager shareDataManager].aryLocalQuestions objectAtIndex:i];
        NSMutableDictionary *responseData = [[DataManager shareDataManager] getResponseWithJuror:self.juror.tid question:self.theQuestion];
        NSLog(@"%d: %d vs %ld", i , curGroup, (long)self.theQuestion.groupId);
        
        if(curGroup != self.theQuestion.groupId){
            curGroup = (int)self.theQuestion.groupId;
            GroupInfo *group = [[DataManager shareDataManager] getGroup:curGroup];
            UILabel *temp1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 20)];
            temp1.numberOfLines = 0;
            [temp1 setFont:[UIFont fontWithName: @"Trebuchet MS" size: 16.0f]];
            [temp1 setText:[NSString stringWithFormat:@"%@", group.groupTitle]];
            CGSize textViewSize1 = [temp1 sizeThatFits:CGSizeMake(350, FLT_MAX)];
            if(addedY + textViewSize1.height >= self.frame.size.height){
                xVal++;
                addedY = 10;
                selfWidth = selfWidth + maxWidth;
            }
            UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake((maxWidth*xVal)+20, addedY, maxWidth, textViewSize1.height)];

            [yourLabel setTextColor:[UIColor redColor]];
            [yourLabel setBackgroundColor:[UIColor clearColor]];
            [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 16.0f]];
            [yourLabel setText:[NSString stringWithFormat:@"%@", group.groupTitle]];
            [_mainView addSubview:yourLabel];
            addedY += textViewSize1.height;
        }
        
//        if(i%37 == 0 && i != 0){
//            xVal++;
//            addedY = 0;
//        }
        
        
        UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 20)];
        temp.numberOfLines = 0;
        [temp setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        [temp setText:[NSString stringWithFormat:@"%d. %@: %@", i, self.theQuestion.sumQuestion, [responseData objectForKey:@"response"]]];
        CGSize textViewSize = [temp sizeThatFits:CGSizeMake(350, FLT_MAX)];
        if(addedY + textViewSize.height >= (self.frame.size.height)){
            xVal++;
            addedY = 10;
            selfWidth = selfWidth + maxWidth;
        }
//        if (maxWidth < textViewSize.width) {
//            maxWidth = textViewSize.width;
//        }

        UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake((maxWidth*xVal)+20, addedY, maxWidth, textViewSize.height)];
        yourLabel.numberOfLines = 0;
        addedY = addedY + textViewSize.height;
        
        [yourLabel setTextColor:[UIColor blackColor]];
        [yourLabel setBackgroundColor:[UIColor clearColor]];
        [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        [yourLabel setText:[NSString stringWithFormat:@"%d. %@: %@", i, self.theQuestion.sumQuestion, [responseData objectForKey:@"response"]]];
        [_mainView addSubview:yourLabel];
    }
//    if ([[DataManager shareDataManager].aryLocalQuestions count] % 30 != 0 && ([[DataManager shareDataManager].aryLocalQuestions count] > 30)) {
        selfWidth = selfWidth + maxWidth;
//    }
    
    [_mainView setFrame:CGRectMake(0, 0, selfWidth, self.frame.size.height)];
    [_mainScroll addSubview:_mainView];
    [_mainScroll setContentSize:CGSizeMake(selfWidth, self.frame.size.height)];
    [self addSubview:_mainScroll];
    _close.frame = CGRectMake(self.frame.size.width - _close.frame.size.width, 0, _close.frame.size.width, _close.frame.size.height);
    [self addSubview:_close];
    
    //NSString *question = [[[QuestionInfo alloc] init[[DataManager shareDataManager].aryLocalQuestions objectAtIndex:0];
    //NSLog(@"%@", ;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
