//
//  NewSurveyView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class CaseInfo;

@protocol NewSurveyViewDelegate <NSObject>

- (void) addedNewSurvey:(UIView *)view survey:(CaseInfo *)survey;
- (void) updateSurvey:(UIView *)view old:(CaseInfo *)oldSurvey new:(CaseInfo *)newSurvey;
- (void) canceledNewSurvey:(UIView *)view;

@end

@interface NewSurveyView : UIView
{

}

@property (nonatomic, assign) id<NewSurveyViewDelegate> delegate;

- (void) _init;
- (void) _init:(CaseInfo *)mySurvey;

@end
