//
//  SearchJurorView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "SearchJurorView.h"

#import "DataManager.h"
#import "SampleQuestions.h"

#import "LocalJurorInfo.h"

#import "JurorSmallView.h"

#import <QuartzCore/QuartzCore.h>

@interface SearchJurorView()
{

}

@property (nonatomic, assign) IBOutlet UITextField *txtKeyword;
@property (nonatomic, assign) IBOutlet UIScrollView *svJurors;

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) IBOutlet UIButton *btnCreateANew;

@property (nonatomic, retain) NSString *keywordString;

- (IBAction)onCancel:(id)sender;

- (IBAction)onChangedKeyword:(id)sender;
- (IBAction)onAddNewJuror:(id)sender;

@end

@implementation SearchJurorView

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

- (void) _init
{
    self.lblTitle.text = @"Select Jurors";
    self.btnCreateANew.hidden = NO;
    
    self.keywordString = nil;
    
    [self loadJurors];
}

- (void) setKeyword:(NSString *)keyword
{
    self.lblTitle.text = @"Search Jurors";
    self.btnCreateANew.hidden = YES;
    
    self.keywordString = keyword;
    self.txtKeyword.text = keyword;
    
    [self loadJurors];
}

- (void) loadJurors
{
    for (UIView *subview in self.svJurors.subviews) {
        
        [subview removeFromSuperview];
    }
    
    NSString *keyword = self.txtKeyword.text;
    
    NSMutableArray *aryJurors = [DataManager shareDataManager].aryLocalJurors;
    
    int index = 0;
    for (LocalJurorInfo *juror in aryJurors) {
        
        BOOL isSelectedJuror = [[DataManager shareDataManager] isSelectedJuror:juror.tid];
        
        if(isSelectedJuror && self.keywordString == nil)
            continue;
        
        if([DataManager shareDataManager].sortJurorNumbers != nil)
        {
            if(![[DataManager shareDataManager].sortJurorNumbers containsObject:juror.personality])
                continue;
        }
        
        if(keyword.length > 0)
        {
            keyword = [keyword lowercaseString];
            
            NSRange rangeName = [[juror.name lowercaseString] rangeOfString:keyword];
            //NSRange rangeNote = [[juror.note lowercaseString] rangeOfString:keyword];
            NSRange rangeNumber = [[juror.personality lowercaseString] rangeOfString:keyword];
            
            if(rangeName.location >= juror.name.length /*&& rangeNote.location >= juror.note.length*/ && rangeNumber.location >= juror.personality.length)
            {
                continue;
            }
        }
        
        JurorSmallView *mainJurorView =  [[[NSBundle mainBundle] loadNibNamed:@"JurorSmallView" owner:self options:nil] objectAtIndex:0];
        mainJurorView.tag = 10000 + index;
        mainJurorView.viewTop.tag = 10000 + index;
        mainJurorView.frame = CGRectMake((index / 3) * (mainJurorView.frame.size.width + 30), (index % 3) * (mainJurorView.frame.size.height + 30), mainJurorView.frame.size.width, mainJurorView.frame.size.height);
//        mainJurorView.delegate = self;
        
        [mainJurorView setLocalJurorInfo:juror];
        
        [self.svJurors addSubview:mainJurorView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJuror:)];
        [mainJurorView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer = nil;
        
        index ++;
    }
    
    self.svJurors.contentSize = CGSizeMake(((index - 1) / 2 + 1) * (190 + 20), self.svJurors.frame.size.height);
}

- (void) tapJuror:(UITapGestureRecognizer *)gesture
{
    JurorSmallView *jurorSmallView = (JurorSmallView *)gesture.view;
    LocalJurorInfo *juror = jurorSmallView.juror;
    
    if(self.keywordString)
        [self.delegate showWithSearchJuror:juror.tid];
    else
        [self.delegate selectWithSearchJuror:juror.tid];
}

- (IBAction)onChangedKeyword:(id)sender
{
    [self loadJurors];
}

- (IBAction)onAddNewJuror:(id)sender
{
    [self.delegate addNewJurorWithSearchJuror];
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate cancelWithSearchJuror];
}

@end
