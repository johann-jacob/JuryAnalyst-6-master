//
//  OpenQuestionaireView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol OpenQuestionaireViewDelegate <NSObject>

- (void) onOpenQuestionaire;

@end

@interface OpenQuestionaireView : UIView
{

}

@property (nonatomic, assign) id<OpenQuestionaireViewDelegate> delegate;

- (void) _init;

@end
