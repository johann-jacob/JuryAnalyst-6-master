//
//  SortView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "SortView.h"

#import "DataManager.h"


@interface SortView()
{
    int _currentSortOption;
}

@property (nonatomic, assign) IBOutlet UIButton *btnWithStrike;
@property (nonatomic, assign) IBOutlet UIButton *btnWithCauseStrike;
@property (nonatomic, assign) IBOutlet UIButton *btnWithPreemptStrike;
@property (nonatomic, assign) IBOutlet UIButton *btnWithHardStrike;
@property (nonatomic, assign) IBOutlet UIButton *btnWithoutStrike;

@property (nonatomic, assign) IBOutlet UITextField *txtSortOption;
@property (nonatomic, assign) IBOutlet UITextField *txtSortJurorNumbers;

@property (nonatomic, assign) IBOutlet UIPickerView *sortPicker;

- (IBAction)onShowWithStrike:(id)sender;
- (IBAction)onShowWithCauseStrike:(id)sender;
- (IBAction)onShowWithPreemptStrike:(id)sender;
- (IBAction)onShowWithHardStrike:(id)sender;
- (IBAction)onShowWithoutStrike:(id)sender;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

@end

@implementation SortView

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
    [self.btnWithStrike setSelected:([DataManager shareDataManager].showWithCauseStrike | [DataManager shareDataManager].showWithHardStrike | [DataManager shareDataManager].showWithPreemptStrike)];
    
    [self.btnWithCauseStrike setSelected:[DataManager shareDataManager].showWithCauseStrike];
    [self.btnWithHardStrike setSelected:[DataManager shareDataManager].showWithHardStrike];
    [self.btnWithPreemptStrike setSelected:[DataManager shareDataManager].showWithPreemptStrike];
    
    [self.btnWithoutStrike setSelected:[DataManager shareDataManager].showWithoutStrike];
    
    _currentSortOption = [DataManager shareDataManager].sortOption;
    
    self.sortPicker.hidden = YES;
    
    [self updateUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void) tapScreen
{
    
    self.sortPicker.hidden = YES;
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate onCancelSortSetting];
}

- (IBAction)onDone:(id)sender
{
    [DataManager shareDataManager].showWithoutStrike = self.btnWithoutStrike.isSelected;
    
    [DataManager shareDataManager].showWithCauseStrike = self.btnWithCauseStrike.isSelected;
    [DataManager shareDataManager].showWithHardStrike = self.btnWithHardStrike.isSelected;
    [DataManager shareDataManager].showWithPreemptStrike = self.btnWithPreemptStrike.isSelected;
    
    [DataManager shareDataManager].sortOption = _currentSortOption;
    
    NSString *jurorNumber = [self.txtSortJurorNumbers.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(jurorNumber.length > 0)
    {
        [DataManager shareDataManager].sortJurorNumbers = [[NSArray alloc] initWithArray:[jurorNumber componentsSeparatedByString:@","] copyItems:YES];
    }
    else
    {
        [DataManager shareDataManager].sortJurorNumbers = nil;
    }
    
    self.sortPicker.hidden = YES;
    
    [self.delegate onDoneSortSetting];
}

- (IBAction)onShowWithStrike:(id)sender
{
    BOOL isSelected = ![self.btnWithStrike isSelected];
    
    [self.btnWithStrike setSelected:isSelected];
    
    [self.btnWithCauseStrike setSelected:isSelected];
    [self.btnWithHardStrike setSelected:isSelected];
    [self.btnWithPreemptStrike setSelected:isSelected];
    
    [self updateUI];
}

- (IBAction)onShowWithCauseStrike:(id)sender
{
    BOOL selected = !self.btnWithCauseStrike.isSelected;
    
    [self.btnWithCauseStrike setSelected:selected];
    
    if(!self.btnWithCauseStrike.isSelected && !self.btnWithHardStrike.isSelected && !self.btnWithPreemptStrike.isSelected)
    {
        [self.btnWithStrike setSelected:NO];
    }
    else
    {
        [self.btnWithStrike setSelected:YES];
    }
    
    [self updateUI];
}

- (IBAction)onShowWithPreemptStrike:(id)sender
{
    BOOL selected = !self.btnWithPreemptStrike.isSelected;
    
    [self.btnWithPreemptStrike setSelected:selected];
    
    if(!self.btnWithCauseStrike.isSelected && !self.btnWithHardStrike.isSelected && !self.btnWithPreemptStrike.isSelected)
    {
        [self.btnWithStrike setSelected:NO];
    }
    else
    {
        [self.btnWithStrike setSelected:YES];
    }
    
    [self updateUI];
}

- (IBAction)onShowWithHardStrike:(id)sender
{
    BOOL selected = !self.btnWithHardStrike.isSelected;
    
    [self.btnWithHardStrike setSelected:selected];
    
    if(!self.btnWithCauseStrike.isSelected && !self.btnWithHardStrike.isSelected && !self.btnWithPreemptStrike.isSelected)
    {
        [self.btnWithStrike setSelected:NO];
    }
    else
    {
        [self.btnWithStrike setSelected:YES];
    }
    
    [self updateUI];
}

- (IBAction)onShowWithoutStrike:(id)sender
{
    BOOL isSelected = ![self.btnWithoutStrike isSelected];
    [self.btnWithoutStrike setSelected:isSelected];
    
    [self updateUI];
}

- (void) updateUI
{
    [self.btnWithStrike setImage:[UIImage imageNamed:(self.btnWithStrike.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    
    [self.btnWithCauseStrike setImage:[UIImage imageNamed:(self.btnWithCauseStrike.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    [self.btnWithHardStrike setImage:[UIImage imageNamed:(self.btnWithHardStrike.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    [self.btnWithPreemptStrike setImage:[UIImage imageNamed:(self.btnWithPreemptStrike.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
    
    [self.btnWithoutStrike setImage:[UIImage imageNamed:(self.btnWithoutStrike.isSelected ? @"btn_check_on" : @"btn_check_off")] forState:UIControlStateNormal];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtSortOption)
    {
        self.sortPicker.hidden = NO;
        
        return NO;
    }
    
    return YES;
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
        return @"Location";
    else if(row == 1)
        return @"Rating";
    else if(row == 2)
        return @"Alphabetical";

    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *value = @"";
    
    if(row == 0)
        value = @"Location";
    else if(row == 1)
        value = @"Rating";
    else if(row == 2)
        value = @"Alphabetical";
    
    _currentSortOption = (int)row;
    
    self.txtSortOption.text = value;
}

@end
