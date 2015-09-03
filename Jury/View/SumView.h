//
//  SumView.h
//  JuryAnalyst
//
//  Created by Jake D on 7/30/15.
//  Copyright (c) 2015 Alioth. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef JuryAnalyst_SumView_h
#define JuryAnalyst_SumView_h


#endif

@class LocalJurorInfo, QuestionInfo;

@protocol SumViewDelegate <NSObject>

- (void) closeSummary:(UIView *)view;

@end

@interface SumView :UIView
{
    
}

@property (nonatomic, assign) id<SumViewDelegate> delegate;
- (void) _initWithJuror:(LocalJurorInfo *)juror;

@end
