//
//  JurorSmallView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class LocalJurorInfo;

@protocol JurorSmallViewDelegate <NSObject>

- (void) onJurorSmallViewStriked:(NSString *)tid;
- (void) onSelectJurorWithView:(UIView *)view;

@end

@interface JurorSmallView : UIView
{
    BOOL isYellow;

}

@property (nonatomic) BOOL isYellow;

@property (nonatomic, assign) id<JurorSmallViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet UIView *viewTop;

@property (nonatomic, retain) LocalJurorInfo *juror;

- (void) setLocalJurorInfo:(LocalJurorInfo *)localJuror;

@end
