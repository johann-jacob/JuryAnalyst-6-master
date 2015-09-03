//
//  SaveQuestionaireView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol SaveQuestionaireViewDelegate <NSObject>

@end

@interface SaveQuestionaireView : UIView
{

}

@property (nonatomic, assign) id<SaveQuestionaireViewDelegate> delegate;

- (void) _init;

@end
