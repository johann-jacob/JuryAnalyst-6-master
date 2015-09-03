//
//  EditLocalJurorView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class LocalJurorInfo;

@protocol EditLocalJurorViewDelegate <NSObject>

- (void) onDoneEditLocalJuror:(UIView *)view juror:(LocalJurorInfo *)juror;
- (void) onCancelEditLocalJuror:(UIView *)view;

@end

@interface EditLocalJurorView : UIView
{

}

@property (nonatomic, assign) id<EditLocalJurorViewDelegate> delegate;

- (void) _init;
- (void) _initWithTID:(NSString *)tid;
- (void) _initWithJuror:(LocalJurorInfo *)juror;

@end
