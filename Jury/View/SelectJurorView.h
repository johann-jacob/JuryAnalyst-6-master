//
//  SelectJurorView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol SelectJurorViewDelegate <NSObject>

- (void) cancelWithSelection;
- (void) createJurorWithSelection;
- (void) selectJurorWithSelection;

@end

@interface SelectJurorView : UIView
{

}

@property (nonatomic, assign) id<SelectJurorViewDelegate> delegate;

@end
