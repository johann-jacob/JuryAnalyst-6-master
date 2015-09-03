//
//  JurorResponseView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>


@class LocalJurorInfo;
@class QuestionInfo;

@protocol JurorResponseViewDelegate <NSObject>

- (void) cancelJurorResponse;
- (void) doneJurorResponse:(NSString *)tid response:(NSString *)response;

@end

@interface JurorResponseView : UIView
{

}

@property (nonatomic, assign) id<JurorResponseViewDelegate> delegate;

- (void) _init:(LocalJurorInfo *)juror question:(QuestionInfo *)question;
- (void) _init;

@end
