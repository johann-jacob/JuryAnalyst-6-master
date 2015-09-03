//
//  JurorBigView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@class LocalJurorInfo;

@protocol JurorBigViewDelegate <NSObject>

- (void) onJurorStriked:(NSString *)tid;

@end

@interface JurorBigView : UIView
{

}

@property (nonatomic, assign) id<JurorBigViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet UIView *viewTop;

@property (nonatomic, retain) LocalJurorInfo *juror;

- (void) setLocalJurorInfo:(LocalJurorInfo *)localJuror;

@end
