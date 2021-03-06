//
//  Y6TemplateViewController.h
//
//  Created by Ysix on 14/01/13.
//

#define STATUS_BAR_HEIGHT 20
#define SIZE_OF_KEYBOARD_IPHONE SIZE_OF_KEYBOARD
#define SIZE_OF_KEYBOARD (keyboardHeight) //  != -1 ? keyboardHeight : (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 162 : 216))

#if __has_include("Y6DimSideMenuViewController.h")
#import "Y6DimSideMenuViewController.h"
@interface Y6TemplateViewController : Y6DimSideMenuViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
#else

#if __has_include("Y6SideMenuViewController.h")
#import "Y6SideMenuViewController.h"
@interface Y6TemplateViewController : Y6SideMenuViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
#else

#import <UIKit/UIKit.h>
@interface Y6TemplateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
#endif
#endif
{
    UIView *referenceView;
    
    int heightHeaderInit;
    int heightFooterInit;

    //Header Part
	UIView		*statusBarView;
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

	// keayboard management
	CGFloat keyboardHeight;

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
@property (nonatomic, retain) UILabel *pageTitleLB;
@property (nonatomic, retain) UIScrollView *bodyView;
@property (nonatomic, retain) UIView *footerView;

- (id)initWithHeaderWithBackground:(UIImage *)image AndFooterHeight:(int)footerHeight;
- (id)initWithHeaderHeight:(int)headerHeight andFooterHeight:(int)footerHeight;

- (void)setStatusBarBackground:(UIImage *)image;
- (void)setStatusBarBackgroundColor:(UIColor *)color;
- (void)setHeaderBackground:(UIImage *)image;
- (void)setHeaderLogo:(UIImage *)image;
- (void)setPageTitle:(NSString *)title;
- (void)setBackButtonImage:(NSString *)imageName;


- (void)drawViewIn:(UIInterfaceOrientation)orientation withDuration:(NSTimeInterval)duration;

- (void)hideFooterAnimated:(BOOL)animated;

- (void)displayInfo:(NSString *)infos onView:(UIView *)superView;
- (void)hideInfo;

- (void)goBack;
- (void)goBackAnimated:(BOOL)animated;

// keyboard management

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
- (void)handleKeyboardMoves;

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

