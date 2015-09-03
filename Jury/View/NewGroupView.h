//
//  NewGroupView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class GroupInfo;

@protocol NewGroupViewDelegate <NSObject>

- (void) doneNewGroup:(UIView *)view group:(GroupInfo *)group;
- (void) doneEditGroup:(UIView *)view group:(GroupInfo *)group;
- (void) cancelNewGroup:(UIView *)view;

@end

@interface NewGroupView : UIView
{

}

@property (nonatomic, assign) id<NewGroupViewDelegate> delegate;

- (void) _init;
- (void) _initWithId:(int)groupId;

@end
