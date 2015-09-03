//
//  SearchJurorView.h
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import <UIKit/UIKit.h>

@protocol SearchJurorViewDelegate <NSObject>

- (void) cancelWithSearchJuror;
- (void) selectWithSearchJuror:(NSString *)tid;
- (void) showWithSearchJuror:(NSString *)tid;
- (void) addNewJurorWithSearchJuror;

@end

@interface SearchJurorView : UIView
{

}

@property (nonatomic, assign) id<SearchJurorViewDelegate> delegate;

- (void) _init;
- (void) setKeyword:(NSString *)keyword;

@end
