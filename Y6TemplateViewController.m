//
//  Y6TemplateViewController.m
//
//  Created by Ysix on 14/01/13.
//

#import "Y6TemplateViewController.h"

@interface Y6TemplateViewController ()

@end

@implementation Y6TemplateViewController

@synthesize headerView, bodyView, footerView, pageTitleLB;

- (id)init
{
	if (self = [super init])
	{
		heightHeaderInit = -1;
		heightFooterInit = -1;
	}
	return self;
}

- (id)initWithHeaderWithBackground:(UIImage *)image AndFooterHeight:(int)footerHeight;
{
	if (self = [self initWithHeaderHeight:-2 andFooterHeight:footerHeight])
	{
		[self setHeaderBackground:image];
	}
	return self;
}

- (id)initWithHeaderHeight:(int)headerHeight andFooterHeight:(int)footerHeight
{
	if (self = [self init])
	{
		heightHeaderInit = headerHeight;
		heightFooterInit = footerHeight;
	}
	return self;
}

- (void)loadView {

	[super loadView];

	if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
		[self setAutomaticallyAdjustsScrollViewInsets:NO];

    if ([self isKindOfClass:[NSClassFromString(@"Y6SideMenuViewController") class]])
    {
        referenceView = (UIView *)[self performSelector:@selector(maineView)];
    }
    else
    {
        referenceView = self.view;
    }
    
	//body part
	bodyView = [[UIScrollView alloc] init];
	[referenceView addSubview:bodyView];


	if ([self respondsToSelector:@selector(prefersStatusBarHidden)] && ![[UIApplication sharedApplication] isStatusBarHidden]) // if iOS >= 7 and statusBar visible
	{
		statusBarView = [[UIView alloc] init];
        if ([self isKindOfClass:[NSClassFromString(@"Y6SideMenuViewController") class]])
            [self.view insertSubview:statusBarView belowSubview:referenceView];
	}

	//header Part
	headerView = [[UIView alloc] init];
	if (headerBkgIV)
	{
		[headerView addSubview:headerBkgIV];
		[headerView sendSubviewToBack:headerBkgIV];
	}
	[referenceView addSubview:headerView];


	if (heightHeaderInit != -1)
	{
		if (heightHeaderInit == -2 && headerBkgIV)
		{
			heightHeaderInit = headerBkgIV.image.size.height;
		}

		pageTitleLB = [[UILabel alloc] init];
		[pageTitleLB setTextAlignment:NSTextAlignmentCenter];
		[pageTitleLB setHidden:YES];
		[headerView addSubview:pageTitleLB];

		backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		[backButton setHidden:(self.navigationController.viewControllers.count == 1)];
		[headerView addSubview:backButton];
	}

	//footer part
	footerView = [[UIView alloc] init];
	[referenceView addSubview:footerView];
}

- (void)setStatusBarBackground:(UIImage *)image
{
	if (statusBarView)
		[statusBarView setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color
{
	if (statusBarView)
		[statusBarView setBackgroundColor:color];
}

- (void)setHeaderBackground:(UIImage *)image
{
	headerBkgIV = [[UIImageView alloc] initWithImage:image];
	if (headerView)
	{
		[headerView addSubview:headerBkgIV];
		[headerView sendSubviewToBack:headerBkgIV];
	}
}

- (void)setHeaderLogo:(UIImage *)image
{
	headerLogoIV = [[UIImageView alloc] initWithImage:image];
	[headerView addSubview:headerLogoIV];

	[headerView sendSubviewToBack:headerLogoIV];
	[headerView sendSubviewToBack:headerBkgIV];
}

- (void)setPageTitle:(NSString *)title
{
	if (headerLogoIV)
		[headerLogoIV setHidden:YES];

	[pageTitleLB setHidden:NO];
	[pageTitleLB setText:title];
}

- (void)setBackButtonImage:(NSString *)imageName
{
	[backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification
											   object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self drawViewIn:[[UIApplication sharedApplication] statusBarOrientation] withDuration:0];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)drawViewIn:(UIInterfaceOrientation)orientation withDuration:(NSTimeInterval)duration
{
	if (duration > 0)
	{
		[self animateDrawViewIn:orientation withDuration:duration];
		return;
	}

    CGRect mainFrame = referenceView.frame;
        
	UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

	if (!((UIInterfaceOrientationIsPortrait(orientation) && UIInterfaceOrientationIsPortrait(currentOrientation)) ||
		  (UIInterfaceOrientationIsLandscape(orientation) && UIInterfaceOrientationIsLandscape(currentOrientation))))
	{
		if ([[UIApplication sharedApplication] isStatusBarHidden])
			mainFrame = CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.height + STATUS_BAR_HEIGHT, mainFrame.size.width - STATUS_BAR_HEIGHT);
		else
			mainFrame = CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.height, mainFrame.size.width);
	}

	if (statusBarView)
	{
		[statusBarView setFrame:CGRectMake(0, 0, self.view.frame.size.width, STATUS_BAR_HEIGHT)];
	}

	if (heightHeaderInit != -1)
	{
		headerView.frame = CGRectMake(0, (statusBarView ? CGRectGetMaxY(statusBarView.frame) : 0), mainFrame.size.width, heightHeaderInit);

		if (headerBkgIV)
		{
			[headerBkgIV setFrame:headerView.bounds];
		}

		if (headerLogoIV)
		{
			[headerLogoIV setFrame:CGRectMake(0, 0, headerLogoIV.image.size.width, headerLogoIV.image.size.height)];
			[headerLogoIV setCenter:CGPointMake(headerView.frame.size.width / 2, headerView.frame.size.height / 2)];
		}

		[pageTitleLB setFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];

        if (backButton.currentImage)
        {
            [backButton setFrame:CGRectMake(0, 0, backButton.currentImage.size.width, backButton.currentImage.size.height)];
            [backButton setCenter:CGPointMake(10 + backButton.frame.size.width / 2, pageTitleLB.center.y)];
        }
        else if (backButton.currentTitle.length)
        {
            [backButton sizeToFit];
            [backButton setFrame:CGRectMake(0, 0, MAX(40, backButton.frame.size.width), MAX(40, backButton.frame.size.height))];
            [backButton setCenter:CGPointMake(10 + backButton.frame.size.width / 2, pageTitleLB.center.y)];
        }
    }
    
	if (heightFooterInit != -1)
	{
		footerView.frame = CGRectMake(0, mainFrame.size.height - heightFooterInit, mainFrame.size.width, heightFooterInit);
	}

	if (heightFooterInit != -1 || heightHeaderInit != -1)
	{
		bodyView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), mainFrame.size.width, footerView.frame.origin.y - CGRectGetMaxY(headerView.frame));
	}
	else
	{
		[bodyView setFrame:CGRectMake(0, (statusBarView ? CGRectGetMaxY(statusBarView.frame) : 0), mainFrame.size.width, mainFrame.size.height - (statusBarView ? CGRectGetMaxY(statusBarView.frame) : 0))];
	}
}

- (void)animateDrawViewIn:(UIInterfaceOrientation)orientation withDuration:(NSTimeInterval)duration
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

	[self drawViewIn:orientation withDuration:0];

	[UIView commitAnimations];
}

- (void)hideFooterAnimated:(BOOL)animated
{
	heightFooterInit = 0;
	[self drawViewIn:[[UIApplication sharedApplication] statusBarOrientation] withDuration:(animated ? 0.25 : 0)];
}

- (void)displayInfo:(NSString *)infos onView:(UIView *)superView
{
	if (infosBlackView == nil)
	{
		infosBlackView = [[UIView alloc] init];
		[infosBlackView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];

		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[infosBlackView addSubview:spinner];

		infosLB = [[UILabel alloc] init];
		[infosLB setBackgroundColor:[UIColor clearColor]];
		[infosLB setTextColor:[UIColor whiteColor]];
		[infosLB setTextAlignment:NSTextAlignmentCenter];
		[infosBlackView addSubview:infosLB];

	}
	else
		[infosBlackView removeFromSuperview];

	[superView addSubview:infosBlackView];
	[infosBlackView setFrame:superView.bounds];

	[spinner setCenter:CGPointMake(infosBlackView.frame.size.width / 2, infosBlackView.frame.size.height / 2)];
	[infosLB setFrame:CGRectMake(0, spinner.frame.origin.y + spinner.frame.size.height + 10, infosBlackView.frame.size.width, 60)];

	[infosBlackView.superview bringSubviewToFront:infosBlackView];
	[infosLB setText:infos];

	[infosBlackView setHidden:NO];
	[spinner startAnimating];
	popUpShowedDate = [NSDate date];
}

- (void)hideInfo
{
	[infosBlackView removeFromSuperview];
	[spinner stopAnimating];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self drawViewIn:toInterfaceOrientation withDuration:duration];
}

- (void)goBack
{
	[self goBackAnimated:YES];
}

- (void)goBackAnimated:(BOOL)animated
{
	if (self.navigationController && [self.navigationController.viewControllers count] > 1)
	{
		[self.navigationController popViewControllerAnimated:animated];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - keyboard methods

- (void)keyboardWillShow:(NSNotification *)notification
{
	keyboardHeight = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	keyboardHeight = 0;
}

- (void)keyboardDidHide:(NSNotification *)notification
{


}

- (void)sideMenuClicked
{
    if ([super respondsToSelector:@selector(sideMenuClicked)])
	[super performSelector:@selector(sideMenuClicked)];

	if (textFieldFirstResponder)
	{
		[self textFieldFirstResponderResign];
	}
}

#pragma mark - TextFieldDelegate functions

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self hidePicker:nil];
	textFieldFirstResponder = textField;
	[bodyView setFrame:CGRectMake(bodyView.frame.origin.x, bodyView.frame.origin.y + decalageBody, bodyView.frame.size.width, bodyView.frame.size.height)];
	decalageBody = 0;

	CGRect frameOnMainView = [textField convertRect:textField.bounds toView:self.view];
	CGFloat viewHeight;
	viewHeight = self.view.frame.size.height;

	if (![self.navigationController.viewControllers containsObject:self] && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
	{
		viewHeight = ([[UIApplication sharedApplication] isStatusBarHidden] ? 320 : 300);
	} // /!\ ce if est la pour resoudre un "bug" qui fait que self.view.frame.size.height n'est pas a la bonne taille pour les modals VC en mode landscape


    if (frameOnMainView.origin.y + frameOnMainView.size.height + 8 > viewHeight - SIZE_OF_KEYBOARD)
    {
        decalageBody = frameOnMainView.origin.y + frameOnMainView.size.height + 8 - (viewHeight - SIZE_OF_KEYBOARD);
        
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.25];

		[bodyView setFrame:CGRectMake(bodyView.frame.origin.x, bodyView.frame.origin.y - decalageBody, bodyView.frame.size.width, bodyView.frame.size.height)];

		[UIView commitAnimations];

	}
	return YES;
}

- (void)textFieldFirstResponderResign
{
	[textFieldFirstResponder resignFirstResponder];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];

	[bodyView setFrame:CGRectMake(bodyView.frame.origin.x, bodyView.frame.origin.y + decalageBody, bodyView.frame.size.width, bodyView.frame.size.height)];

	[UIView commitAnimations];

	decalageBody = 0;
	textFieldFirstResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self textFieldFirstResponderResign];
	return NO;
}

#pragma mark - UIPickerViewDelegate functions

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([titlesForPicker count] >0 && [[titlesForPicker objectAtIndex:0] isKindOfClass:[NSArray class]])
		return [[titlesForPicker objectAtIndex:component] objectAtIndex:row];
	return [titlesForPicker objectAtIndex:row];
}

#pragma mark UIPickerViewDataSource functions

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if ([titlesForPicker count] >0 && [[titlesForPicker objectAtIndex:0] isKindOfClass:[NSArray class]])
		return [titlesForPicker count];
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if ([titlesForPicker count] > 0 && [[titlesForPicker objectAtIndex:0] isKindOfClass:[NSArray class]])
		return [[titlesForPicker objectAtIndex:component] count];
	return [titlesForPicker count];
}

#pragma mark UIPicker others functions

- (void)initPicker
{
	if (textFieldFirstResponder)
	{
		[textFieldFirstResponder resignFirstResponder];
		[bodyView setFrame:CGRectMake(bodyView.frame.origin.x, bodyView.frame.origin.y + decalageBody, bodyView.frame.size.width, bodyView.frame.size.height)];
		decalageBody = 0;
		textFieldFirstResponder = nil;
	}

	if (viewForPicker == nil)
	{
		viewForPicker = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 250)];
		if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
		{
			[viewForPicker setBackgroundColor:[UIColor colorWithRed:0.157 green:0.165 blue:0.224 alpha:1]];
		}
		else
		{
			[viewForPicker setBackgroundColor:[UIColor whiteColor]];

		}
		[self.view addSubview:viewForPicker];
	}

	for (UIView *v in [viewForPicker subviews])
		[v removeFromSuperview];

	UIButton *btnCloseTimePicker;
	UIButton *btnValidTime;

	btnCloseTimePicker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnCloseTimePicker setFrame:CGRectMake(65, 220, 70, 26)];
	[btnCloseTimePicker setTitle:@"Fermer" forState:UIControlStateNormal];
	[btnCloseTimePicker setTag:2];
	[btnCloseTimePicker addTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventTouchDown];

	btnValidTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnValidTime setFrame:CGRectMake(185, 220, 70, 26)];
	[btnValidTime setTitle:@"Valider" forState:UIControlStateNormal];
	[btnValidTime setTag:1];
	[btnValidTime addTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventTouchDown];

	[viewForPicker addSubview:btnCloseTimePicker];
	[viewForPicker addSubview:btnValidTime];

	if (isHourPicker)
	{
		if (datePicker == nil)
		{
			datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
		}
		[viewForPicker addSubview:datePicker];
		[datePicker setDatePickerMode:UIDatePickerModeTime];
	}
	else if (isDatePicker)
	{
		if (datePicker == nil)
		{
			datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
		}
		[viewForPicker addSubview:datePicker];
		[datePicker setDatePickerMode:UIDatePickerModeDate];
	}
	else
	{
		if (pickerToDisplay == nil)
		{
			pickerToDisplay = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
			[pickerToDisplay setShowsSelectionIndicator:YES];
			[pickerToDisplay setDelegate:self];
			[pickerToDisplay setDataSource:self];
		}
		[viewForPicker addSubview:pickerToDisplay];
		[pickerToDisplay selectRow:0 inComponent:0 animated:NO];
	}
	[self.view bringSubviewToFront:viewForPicker];
}

- (void)reloadAndDisplayPicker
{
	[pickerToDisplay reloadAllComponents];

	CGRect rectPicker = [viewForPicker frame];
	if (isHourPicker)
	{
		rectPicker.origin.y = self.view.frame.size.height - viewForPicker.frame.size.height;//160;
	}
	else {
		rectPicker.origin.y = self.view.frame.size.height - viewForPicker.frame.size.height;//210;
	}


	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];

	[viewForPicker setFrame:rectPicker];

	[UIView commitAnimations];
}

- (void)displayHourPickerandReturnChoiceTo:(SEL)selector
{
	isHourPicker = YES;
	isDatePicker = NO;
	[self initPicker];
	sendResultSelector = selector;
	[self reloadAndDisplayPicker];
}

- (void)displayHourPickerandReturnChoiceTo:(SEL)selector withWillHideSelector:(SEL)willHideSelector
{
	willHidePickerSelector = willHideSelector;
	[self displayHourPickerandReturnChoiceTo:selector];
}

- (void)displayDatePickerandReturnChoiceTo:(SEL)selector
{
	isHourPicker = NO;
	isDatePicker = YES;
	[self initPicker];
	sendResultSelector = selector;
	[self reloadAndDisplayPicker];

}

- (void)displayAPickerWith:(NSArray *)choices andReturnChoiceTo:(SEL)selector
{
	isHourPicker = NO;
	isDatePicker = NO;

	[self initPicker];

	if (titlesForPicker == nil)
	{
		titlesForPicker = [[NSMutableArray alloc] init];
	}
	[titlesForPicker removeAllObjects];
	[titlesForPicker addObjectsFromArray:choices];
	sendResultSelector = selector;

	[self reloadAndDisplayPicker];
}

- (void)hidePicker:(id)sender
{
	if (willHidePickerSelector && [self respondsToSelector:willHidePickerSelector])
	{
		[self performSelector:willHidePickerSelector withObject:nil];
	}

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];

	[viewForPicker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, viewForPicker.frame.size.height)];

	[UIView commitAnimations];

	if (sender && [(UIButton *)sender tag])// on enregistre les changement
	{
		if ([(UIButton *)sender tag] == 1)
		{
			if (isDatePicker)
			{
				NSDateFormatter *getDateFormatter = [[NSDateFormatter alloc ] init];
				[getDateFormatter setDateFormat:@"yyyy-MM-dd"];

				[self performSelector:sendResultSelector withObject:[getDateFormatter stringFromDate:[datePicker date]]];
			}
			else if (isHourPicker)
			{
				NSDateFormatter *getHourFormatter = [[NSDateFormatter alloc ] init];
				[getHourFormatter setDateFormat:@"HH:mm"];

				[self performSelector:sendResultSelector withObject:[getHourFormatter stringFromDate:[datePicker date]]];
			}
			else
			{
				if ([titlesForPicker count] >0 && [[titlesForPicker objectAtIndex:0] isKindOfClass:[NSArray class]])
				{
					NSMutableArray *resultArray = [[NSMutableArray alloc] init];
					for (int i = 0; i < [titlesForPicker count]; i++)
					{
						[resultArray addObject:[[titlesForPicker objectAtIndex:i] objectAtIndex:[pickerToDisplay selectedRowInComponent:i]]];
					}
					[self performSelector:sendResultSelector withObject:resultArray];
				}
				else
					[self performSelector:sendResultSelector withObject:[titlesForPicker objectAtIndex:[pickerToDisplay selectedRowInComponent:0]]];
			}
		}
	}
}

@end
