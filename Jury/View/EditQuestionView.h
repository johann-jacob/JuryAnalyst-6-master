//
//  EditQuestionView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class QuestionInfo;

@protocol EditQuestionViewDelegate <NSObject>

- (void) doneNewQuestion:(UIView *)view question:(QuestionInfo *)question;
- (void) doneEditQuestion:(UIView *)view question:(QuestionInfo *)question;
- (void) cancelEditQuestion:(UIView *)view;

@end

@interface EditQuestionView : UIView
{

}

@property (nonatomic, assign) id<EditQuestionViewDelegate> delegate;

- (void) _init;
- (void) _initWithGroupId:(int)groupId;
- (void) _initWithQuestion:(QuestionInfo *)question;

@end
