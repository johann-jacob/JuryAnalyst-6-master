//
//  AskNowView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol AskNowViewDelegate <NSObject>

- (void) onAskNowWithNew;
- (void) onAskNowWithIsAlreadyQuestion:(int)index;

@end

@interface AskNowView : UIView
{

}

@property (nonatomic, assign) id<AskNowViewDelegate> delegate;

- (void) _init;

@end
