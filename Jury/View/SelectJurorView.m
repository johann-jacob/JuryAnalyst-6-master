//
//  SelectJurorView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "SelectJurorView.h"

#import "DataManager.h"
#import "SampleQuestions.h"

#import <QuartzCore/QuartzCore.h>

@interface SelectJurorView()
{

}

- (IBAction)onCancel:(id)sender;
- (IBAction)onCreateJuror:(id)sender;
- (IBAction)onSelectJuror:(id)sender;

@end

@implementation SelectJurorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)onCancel:(id)sender
{
    [self.delegate cancelWithSelection];
}

- (IBAction)onCreateJuror:(id)sender
{
    [self.delegate createJurorWithSelection];
}

- (IBAction)onSelectJuror:(id)sender
{
    [self.delegate selectJurorWithSelection];
}

@end
