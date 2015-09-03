//
//  SortView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol SortViewDelegate <NSObject>

- (void) onDoneSortSetting;
- (void) onCancelSortSetting;

@end

@interface SortView : UIView
{

}

@property (nonatomic, assign) id<SortViewDelegate> delegate;

- (void) _init;

@end
