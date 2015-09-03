//
//  JurorViewSmall.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol SurveyViewDelegate <NSObject>

- (void) selectSurvey:(UIView *)view index:(int)index;

@end

@interface SurveyView : UIView
{

}

@property (nonatomic, assign) id<SurveyViewDelegate> delegate;

- (void) setSurvey:(int)index;

@end
