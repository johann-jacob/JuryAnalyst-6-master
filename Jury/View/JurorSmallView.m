//
//  JurorSmallView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "JurorSmallView.h"

#import "DataManager.h"
#import "SettingManager.h"

#import "CaseInfo.h"

#import "LocalJurorInfo.h"

#import <QuartzCore/QuartzCore.h>

@interface JurorSmallView()
{
    int _index;
}

@property (nonatomic, assign) IBOutlet UILabel *lblName;
@property (nonatomic, assign) IBOutlet UILabel *lblNumber;
@property (nonatomic, assign) IBOutlet UILabel *lblRate;
@property (nonatomic, assign) IBOutlet UILabel *lblOverride;
@property (nonatomic, assign) IBOutlet UIScrollView *svSymbol;

@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol2;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol3;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol4;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalitySymbol5;

@property (nonatomic, assign) IBOutlet UIImageView *ivCharactor;

@property (nonatomic, assign) IBOutlet UILabel *lblPoliticalParty;

@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol2;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol3;
@property (nonatomic, assign) IBOutlet UILabel *lblCauseHardshipSymbol4;

@property (nonatomic, assign) IBOutlet UILabel *lblFrivilousSymbol1;
@property (nonatomic, assign) IBOutlet UILabel *lblFrivilousSymbol2;

@property (nonatomic, assign) IBOutlet UIButton *btnEmptyView;

@property (nonatomic, retain) NSString *tid;

- (IBAction)onClickEmpty:(id)sender;

@end

@implementation JurorSmallView
@synthesize isYellow;
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

- (void) layoutSubviews
{
    if(self.frame.size.width > 280)
    {
        _lblName.font = [UIFont systemFontOfSize:24];
        _lblNumber.font = [UIFont systemFontOfSize:20];
        _lblRate.font = [UIFont systemFontOfSize:20];
         _lblOverride.font = [UIFont systemFontOfSize:20];
        
        _lblPersonalitySymbol1.font = [UIFont systemFontOfSize:20];
        _lblPersonalitySymbol2.font = [UIFont systemFontOfSize:20];
        _lblPersonalitySymbol3.font = [UIFont systemFontOfSize:20];
        _lblPersonalitySymbol4.font = [UIFont systemFontOfSize:20];
        _lblPersonalitySymbol5.font = [UIFont systemFontOfSize:20];
        
        _lblPoliticalParty.font = [UIFont systemFontOfSize:20];
        
        _lblCauseHardshipSymbol1.font = [UIFont systemFontOfSize:20];
        _lblCauseHardshipSymbol2.font = [UIFont systemFontOfSize:20];
        _lblCauseHardshipSymbol3.font = [UIFont systemFontOfSize:20];
        _lblCauseHardshipSymbol4.font = [UIFont systemFontOfSize:20];
        
        _lblFrivilousSymbol1.font = [UIFont systemFontOfSize:20];
        _lblFrivilousSymbol2.font = [UIFont systemFontOfSize:20];
    }
    else if(self.frame.size.width > 200)
    {
        _lblName.font = [UIFont systemFontOfSize:20];
        _lblNumber.font = [UIFont systemFontOfSize:16];
        _lblRate.font = [UIFont systemFontOfSize:20];
        _lblOverride.font = [UIFont systemFontOfSize:20];
        
        _lblPersonalitySymbol1.font = [UIFont systemFontOfSize:16];
        _lblPersonalitySymbol2.font = [UIFont systemFontOfSize:16];
        _lblPersonalitySymbol3.font = [UIFont systemFontOfSize:16];
        _lblPersonalitySymbol4.font = [UIFont systemFontOfSize:16];
        _lblPersonalitySymbol5.font = [UIFont systemFontOfSize:16];
        
        _lblPoliticalParty.font = [UIFont systemFontOfSize:16];
        
        _lblCauseHardshipSymbol1.font = [UIFont systemFontOfSize:16];
        _lblCauseHardshipSymbol2.font = [UIFont systemFontOfSize:16];
        _lblCauseHardshipSymbol3.font = [UIFont systemFontOfSize:16];
        _lblCauseHardshipSymbol4.font = [UIFont systemFontOfSize:16];
        
        _lblFrivilousSymbol1.font = [UIFont systemFontOfSize:16];
        _lblFrivilousSymbol2.font = [UIFont systemFontOfSize:16];
    }
    else if(self.frame.size.width > 160)
    {
        _lblName.font = [UIFont systemFontOfSize:14];
        _lblNumber.font = [UIFont systemFontOfSize:12];
        _lblRate.font = [UIFont systemFontOfSize:14];
         _lblOverride.font = [UIFont systemFontOfSize:14];
        
        _lblPersonalitySymbol1.font = [UIFont systemFontOfSize:12];
        _lblPersonalitySymbol2.font = [UIFont systemFontOfSize:12];
        _lblPersonalitySymbol3.font = [UIFont systemFontOfSize:12];
        _lblPersonalitySymbol4.font = [UIFont systemFontOfSize:12];
        _lblPersonalitySymbol5.font = [UIFont systemFontOfSize:12];
        
        _lblPoliticalParty.font = [UIFont systemFontOfSize:12];
        
        _lblCauseHardshipSymbol1.font = [UIFont systemFontOfSize:12];
        _lblCauseHardshipSymbol2.font = [UIFont systemFontOfSize:12];
        _lblCauseHardshipSymbol3.font = [UIFont systemFontOfSize:12];
        _lblCauseHardshipSymbol4.font = [UIFont systemFontOfSize:12];
        
        _lblFrivilousSymbol1.font = [UIFont systemFontOfSize:12];
        _lblFrivilousSymbol2.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        _lblName.font = [UIFont systemFontOfSize:10];
        _lblNumber.font = [UIFont systemFontOfSize:8];
        _lblRate.font = [UIFont systemFontOfSize:10];
         _lblOverride.font = [UIFont systemFontOfSize:10];
        
        _lblPersonalitySymbol1.font = [UIFont systemFontOfSize:8];
        _lblPersonalitySymbol2.font = [UIFont systemFontOfSize:8];
        _lblPersonalitySymbol3.font = [UIFont systemFontOfSize:8];
        _lblPersonalitySymbol4.font = [UIFont systemFontOfSize:8];
        _lblPersonalitySymbol5.font = [UIFont systemFontOfSize:8];
        
        _lblPoliticalParty.font = [UIFont systemFontOfSize:8];
        
        _lblCauseHardshipSymbol1.font = [UIFont systemFontOfSize:8];
        _lblCauseHardshipSymbol2.font = [UIFont systemFontOfSize:8];
        _lblCauseHardshipSymbol3.font = [UIFont systemFontOfSize:8];
        _lblCauseHardshipSymbol4.font = [UIFont systemFontOfSize:8];
        
        _lblFrivilousSymbol1.font = [UIFont systemFontOfSize:8];
        _lblFrivilousSymbol2.font = [UIFont systemFontOfSize:8];
    }
}

- (void) setLocalJurorInfo:(LocalJurorInfo *)localJuror
{
    self.juror = localJuror;
    
    if(localJuror == nil)
    {
        self.btnEmptyView.hidden = NO;
        return;
    }
    
    self.btnEmptyView.hidden = YES;
    
    self.ivCharactor.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar%d.jpg", localJuror.avatarIndex]];
    
    self.lblName.text = localJuror.name;
    self.lblNumber.text = self.juror.personality;
    self.lblRate.text = [NSString stringWithFormat:@"%@", [[DataManager shareDataManager] getJurorFinalCount:localJuror.tid]];
    self.lblOverride.text = self.juror.overide;
    
    UIColor *backgroundColor = [UIColor blackColor];
    if(self.juror.actionIndex == JA_ACCEPT)
    {
        backgroundColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
    }
    else if(self.juror.actionIndex == JA_CONSIDER)
    {
        backgroundColor = [UIColor colorWithRed:192.0f / 255.0f green:180.0f/ 255.0f blue:1.0f/ 255.0f alpha:1.0];
    }
    else if(self.juror.actionIndex == JA_DECLINE)
    {
        backgroundColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
    }
    else
    {
        backgroundColor = [UIColor blackColor];
    }
    
    self.viewTop.backgroundColor = backgroundColor;
    
    UIColor *greenColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
    
    NSMutableArray *aryPersonalityProfileData = [[DataManager shareDataManager] getPersonalityProfileWithJuror:self.juror.tid];
    
    if(aryPersonalityProfileData.count > 0)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:0] objectForKey:@"symbol"];
        self.lblPersonalitySymbol1.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
        self.lblPersonalitySymbol1.text = symbol;
    }
    if(aryPersonalityProfileData.count > 1)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:1] objectForKey:@"symbol"];
        self.lblPersonalitySymbol2.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
        self.lblPersonalitySymbol2.text = symbol;
    }
    if(aryPersonalityProfileData.count > 2)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:2] objectForKey:@"symbol"];
        self.lblPersonalitySymbol3.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
        self.lblPersonalitySymbol3.text = symbol;
    }
    if(aryPersonalityProfileData.count > 3)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:3] objectForKey:@"symbol"];
        self.lblPersonalitySymbol4.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
        self.lblPersonalitySymbol4.text = symbol;
    }
    if(aryPersonalityProfileData.count > 4)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:4] objectForKey:@"symbol"];
        self.lblPersonalitySymbol5.textColor = ([[DataManager shareDataManager] getValueFromPersonalitySymbol:symbol] > 0 ? greenColor : redColor );
        self.lblPersonalitySymbol5.text = symbol;
    }
    
    NSString *politicalParty = [[DataManager shareDataManager] getPoliticalPartySymbol:self.juror.tid];
    
    if(politicalParty != nil && politicalParty.length > 0)
    {
        CGFloat weight = 0.0f;
        if([politicalParty isEqualToString:@"D"])
        {
            weight = [SettingManager shareSettingManager].valueDemocrat;
        }
        else if([politicalParty isEqualToString:@"R"])
        {
            weight = [SettingManager shareSettingManager].valueRepublican;
        }
        else
        {
            weight = [SettingManager shareSettingManager].valueIndependent;
        }
        
        self.lblPoliticalParty.text = politicalParty;
        self.lblPoliticalParty.backgroundColor = (weight > 0 ? greenColor : redColor );
    }
    
    NSMutableArray *aryCauseHardshipSymbols = [[DataManager shareDataManager] getCauseHardshipSymbol:self.juror.tid];
    if(aryCauseHardshipSymbols)
    {
        if(aryCauseHardshipSymbols.count > 0)
        {
            NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:0];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblCauseHardshipSymbol1.text = [dic objectForKey:@"symbol"];
            //self.lblCauseHardshipSymbol1.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblCauseHardshipSymbol1.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblCauseHardshipSymbol1.backgroundColor = redColor;
            }
            else{
                self.lblCauseHardshipSymbol1.backgroundColor = [UIColor blackColor];
            }
        }
        if(aryCauseHardshipSymbols.count > 1)
        {
            NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:1];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblCauseHardshipSymbol2.text = [dic objectForKey:@"symbol"];
            //self.lblCauseHardshipSymbol2.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblCauseHardshipSymbol2.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblCauseHardshipSymbol2.backgroundColor = redColor;
            }
            else{
                self.lblCauseHardshipSymbol2.backgroundColor = [UIColor blackColor];
            }
        }
        if(aryCauseHardshipSymbols.count > 2)
        {
            NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:2];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblCauseHardshipSymbol3.text = [dic objectForKey:@"symbol"];
            //self.lblCauseHardshipSymbol3.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblCauseHardshipSymbol3.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblCauseHardshipSymbol3.backgroundColor = redColor;
            }
            else{
                self.lblCauseHardshipSymbol3.backgroundColor = [UIColor blackColor];
            }
        }
        if(aryCauseHardshipSymbols.count > 3)
        {
            NSMutableDictionary *dic = [aryCauseHardshipSymbols objectAtIndex:3];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblCauseHardshipSymbol4.text = [dic objectForKey:@"symbol"];
            //self.lblCauseHardshipSymbol4.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblCauseHardshipSymbol4.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblCauseHardshipSymbol4.backgroundColor = redColor;
            }
            else{
                self.lblCauseHardshipSymbol4.backgroundColor = [UIColor blackColor];
            }
        }
    }
    
    NSMutableArray *aryFrivilousSymbols = [[DataManager shareDataManager] getFrivilousSymbol:self.juror.tid];
    if(aryFrivilousSymbols)
    {
        if(aryFrivilousSymbols.count > 0)
        {
            NSMutableDictionary *dic = [aryFrivilousSymbols objectAtIndex:0];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblFrivilousSymbol1.text = [dic objectForKey:@"symbol"];
            //self.lblFrivilousSymbol1.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblFrivilousSymbol1.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblFrivilousSymbol1.backgroundColor = redColor;
            }
            else{
                self.lblFrivilousSymbol1.backgroundColor = [UIColor blackColor];
            }
        }
        if(aryFrivilousSymbols.count > 1)
        {
            NSMutableDictionary *dic = [aryFrivilousSymbols objectAtIndex:1];
            CGFloat weight = [[[dic objectForKey:@"response"] objectForKey:@"weight"] floatValue];
            
            self.lblFrivilousSymbol2.text = [dic objectForKey:@"symbol"];
            //self.lblFrivilousSymbol2.backgroundColor = (weight > 0 ? greenColor : redColor);
            if(weight > 0){
                self.lblFrivilousSymbol2.backgroundColor = greenColor;
            }
            else if(weight < 0){
                self.lblFrivilousSymbol2.backgroundColor = redColor;
            }
            else{
                self.lblFrivilousSymbol2.backgroundColor = [UIColor blackColor];
            }
        }
    }
    
    UIView *symbolView = [[DataManager shareDataManager] getSurveySymbolView:self.juror.tid];
    
    if(self.svSymbol.frame.size.width > symbolView.frame.size.width)
        symbolView.center = CGPointMake(self.svSymbol.frame.size.width / 2, self.svSymbol.frame.size.height / 2);
    
    [self.svSymbol addSubview:symbolView];
    self.svSymbol.contentSize = symbolView.frame.size;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strike)];
    [tapGesture setNumberOfTouchesRequired:2];
    [self addGestureRecognizer:tapGesture];
    
    tapGesture = nil;
}

- (void) strike
{
    [self.delegate onJurorSmallViewStriked:self.juror.tid];
}

- (IBAction)onClickEmpty:(id)sender
{
    [self.delegate onSelectJurorWithView:self];
}

@end
