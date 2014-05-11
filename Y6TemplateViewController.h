//
//  Y6TemplateViewController.h
//
//  Created by Ysix on 14/01/13.
//

#import <UIKit/UIKit.h>

#define STATUS_BAR_HEIGHT 20

#define SIZE_OF_KEYBOARD_IPHONE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 162 : 216)


@interface Y6TemplateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int heightHeaderInit;
    int heightFooterInit;
    BOOL addStatusBarHeightOniOS7;

    //Header Part
    UIView      *headerView;
    UIImageView *headerBkgIV;
    UIImageView *headerLogoIV;
    UILabel     *pageTitleLB;
    UIButton    *backButton;


    //Body Part
    UIScrollView *bodyView;
    
    //Footer Part
    UIView *footerView;
    
    //Display Infos
    UIView                  *infosBlackView;
    UILabel                 *infosLB;
    UIActivityIndicatorView *spinner;
    NSDate                  *popUpShowedDate;
    
    // textfield management
    int     decalageBody;
    UIResponder *textFieldFirstResponder;
    
    // Pickers management
    UIView       *viewForPicker;
    UIPickerView *pickerToDisplay;
    UIDatePicker *datePicker;
    NSMutableArray *titlesForPicker;
    SEL sendResultSelector;
    SEL willHidePickerSelector;
    BOOL    isHourPicker;
    BOOL    isDatePicker;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *bodyView;
@property (nonatomic, retain) UIView *footerView;

- (id)initWithHeaderWithBackground:(UIImage *)image AndFooterHeight:(int)footerHeight;
- (id)initWithHeaderHeight:(int)headerHeight andFooterHeight:(int)footerHeight;

- (void)setHeaderBackground:(UIImage *)image;
- (void)setHeaderLogo:(UIImage *)image;
- (void)setPageTitle:(NSString *)title;
- (void)setBackButtonImage:(NSString *)imageName;


- (void)drawViewIn:(UIInterfaceOrientation)orientation withDuration:(NSTimeInterval)duration;

- (void)displayInfo:(NSString *)infos onView:(UIView *)superView;
- (void)hideInfo;

- (void)goBack;
- (void)goBackAnimated:(BOOL)animated;

// textfield management
- (void)textFieldFirstResponderResign;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// picker management
- (void)displayAPickerWith:(NSArray *)choices andReturnChoiceTo:(SEL)selector;
- (void)displayHourPickerandReturnChoiceTo:(SEL)selector;
- (void)displayHourPickerandReturnChoiceTo:(SEL)selector withWillHideSelector:(SEL)willHideSelector;
- (void)displayDatePickerandReturnChoiceTo:(SEL)selector;
- (void)hidePicker:(id)sender;


@end

