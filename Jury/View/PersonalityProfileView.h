//
//  PersonalityProfileView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol PersonalityProfileViewDelegate <NSObject>

- (void) onCancelPersonalityProfile;
- (void) onDonePersonalityProfile:(NSMutableArray *)aryPersonalData;

@end

@interface PersonalityProfileView : UIView
{

}

@property (nonatomic, assign) id<PersonalityProfileViewDelegate> delegate;

- (void) _initWithPersonalData:(NSMutableArray *)aryPersonalData;

@end
