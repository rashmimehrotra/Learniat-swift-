//
//  SSColorPopOverViewController.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "SSColorPopOverViewController.h"

@interface SSColorPopOverViewController ()

@end

@implementation SSColorPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Counter=0;

    
    float slidervalue=0;
//    int selecteColorButton = 0;
    
    if (slidervalue<=0) {
        slidervalue=4;
    }

    
    UISlider *progressbar = [[UISlider alloc]initWithFrame:CGRectMake(15, 50, [self rect].size.width-30,30)];
    [self.view addSubview:progressbar];
    progressbar.tintColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0];
    progressbar.maximumValue = 40;
    [progressbar setValue:slidervalue];
    [progressbar addTarget:self action:@selector(progressBarValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressbar.center.x, 80, 100, 24)];
    fontLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    fontLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [self.view addSubview:fontLabel];
    [fontLabel setText:[NSString stringWithFormat:@"%d points",(int)slidervalue]];
    
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(15, 135, 370, 1)];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:view];
    
       colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],[UIColor colorWithRed:121.0/255.0 green:11.0/255.0 blue:29.0/255.0 alpha:1.0],[UIColor colorWithRed:52.0/255.0 green:3.0/255.0 blue:11.0/255.0 alpha:1.0],[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],[UIColor colorWithRed:243.0/255.0 green:157.0/255.0 blue:171.0/255.0 alpha:1.0],[UIColor colorWithRed:247.0/255.0 green:49.0/255.0 blue:237.0/255.0 alpha:1.0],[UIColor colorWithRed:86.0/255.0 green:3.0/255.0 blue:82.0/255.0 alpha:1.0],[UIColor colorWithRed:116.0/255.0 green:30.0/255.0 blue:236.0/255.0 alpha:1.0],[UIColor colorWithRed:122.0/255.0 green:118.0/255.0 blue:250.0/255.0 alpha:1.0],[UIColor colorWithRed:7.0/255.0 green:1.0/255.0 blue:181.0/255.0 alpha:1.0],[UIColor colorWithRed:4.0/255.0 green:1.0/255.0 blue:76.0/255.0 alpha:1.0],[UIColor colorWithRed:16.0/255.0 green:196.0/255.0 blue:236.0/255.0 alpha:1.0],[UIColor colorWithRed:2.0/255.0 green:77.0/255.0 blue:94.0/255.0 alpha:1.0],[UIColor colorWithRed:98.0/255.0 green:251.0/255.0 blue:154.0/255.0 alpha:1.0],[UIColor colorWithRed:7.0/255.0 green:148.0/255.0 blue:30.0/255.0 alpha:1.0],[UIColor colorWithRed:2.0/255.0 green:68.0/255.0 blue:13.0/255.0 alpha:1.0],[UIColor colorWithRed:94.0/255.0 green:101.0/255.0 blue:9.0/255.0 alpha:1.0],[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:250.0/255.0 green:107.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:71.0/255.0 green:107.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:95.0/255.0 green:101.0/255.0 blue:92.0/255.0 alpha:1.0], nil];

   
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<7;j++)
        {
            Counter++;
            
            UIButton *circleView = [[UIButton alloc] initWithFrame:CGRectMake(55*j+15,55*i+180,35,35)];
            circleView.alpha = 0.6;
            circleView.layer.cornerRadius = 17.50;
            if(Counter<23)
            circleView.backgroundColor = [colorArray objectAtIndex:Counter-1];
            [self.view addSubview:circleView];
            [circleView addTarget:self action:@selector(onColourImage:) forControlEvents:UIControlEventTouchUpInside];
            [circleView setTag:Counter];
            if(Counter==4)
            {
                
                [circleView setImage:[UIImage imageNamed:@"Tick_mark_image"] forState:UIControlStateNormal];
            }
        
        }
    }
    
    
	// Do any additional setup after loading the view.
}

/*- this function is called when teacher taps on colors button */

-(IBAction)onColourImage:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    [button setImage:[UIImage imageNamed:@"Tick_mark_image"] forState:UIControlStateNormal];
    
    if(button.tag-1 <= [colorArray count])
    [[self delegate]onBlueColorToolAction:[colorArray objectAtIndex:button.tag-1]];
    
    
    for(int i=1; i<=21; i++)
    {
        if(i != button.tag)
        {
            
            UIButton *button2=(UIButton *)[self.view viewWithTag:i];
            [button2 setImage:nil forState:UIControlStateNormal];
            
            
            
        }
        
    }
    [[self popOverController]dismissPopoverAnimated:YES];
    
    
}

/*- this function is called when brush size slider value changed */


- (void) progressBarValueChanged: (UISlider *)sender
{
    int x = sender.value;
    [fontLabel setText:[NSString stringWithFormat:@"%d points",x]];
    [[self delegate]setDrawingBrushWidth:x];
}

- (IBAction)onBlueColorToolAction:(id)sender {
    
    if ([mBlueColorButton.imageView.image isEqual:[UIImage imageNamed:@"popup_tool_color_blue_selected"] ])
	{
    }
    else
	{
        [mBlueColorButton setImage:[UIImage imageNamed:@"popup_tool_color_blue_selected"] forState:UIControlStateNormal];
		[mRedColorButton setImage:[UIImage imageNamed:@"popup_tool_color_red_active"] forState:UIControlStateNormal];
        [mGreenColorButton setImage:[UIImage imageNamed:@"popup_tool_color_green_active"] forState:UIControlStateNormal];
        [[self delegate] onBlueColorToolAction:sender];
        _lastSelectedColour = 0;

    }
    
}
/*- this function is called when brush size slider value changed */


- (IBAction)setDrawingBrushWidth:(int)width {
	
    if ([mGreenColorButton.imageView.image isEqual:[UIImage imageNamed:@"popup_tool_color_green_selected"] ])
	{
    }
    else
	{
        [mBlueColorButton setImage:[UIImage imageNamed:@"popup_tool_color_blue_active"] forState:UIControlStateNormal];
		[mRedColorButton setImage:[UIImage imageNamed:@"popup_tool_color_red_active"] forState:UIControlStateNormal];
        [mGreenColorButton setImage:[UIImage imageNamed:@"popup_tool_color_green_selected"] forState:UIControlStateNormal];
        // [[self delegate] setDrawingBrushWidth:sender];
        _lastSelectedColour = 1;

    }
    
}

- (IBAction)onRedColorToolAction:(id)sender {
    
    if ([mRedColorButton.imageView.image isEqual:[UIImage imageNamed:@"popup_tool_color_red_selected"] ])
	{
    }
    else
	{
		[mRedColorButton setImage:[UIImage imageNamed:@"popup_tool_color_red_selected"] forState:UIControlStateNormal];
        [mGreenColorButton setImage:[UIImage imageNamed:@"popup_tool_color_green_active"] forState:UIControlStateNormal];
        [mBlueColorButton setImage:[UIImage imageNamed:@"popup_tool_color_blue_active"] forState:UIControlStateNormal];
         [[self delegate] onRedColorToolAction:sender];
        _lastSelectedColour = 2;
    }
    
}

- (void)setSelectedColor:(NSInteger)selectedColor
{
    switch (selectedColor) {
        case 0:
            [self onBlueColorToolAction:Nil];
            break;
            
        case 1:
            [self setDrawingBrushWidth:0];
            break;
            
        case 2:
            [self onRedColorToolAction:Nil];
            break;
    }
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    //nslog(@"Amith4");

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setRect:(CGRect)rect
{
    _rect = rect;
    
}
-(CGRect)rect
{
    
    return _rect;
}

- (void) setDelegate:(id) del {
	
	
		
	
	_delegate = del;
}

- (id) delegate {
	
	return _delegate;
}
- (void) setPopOverController:(id) pop {
	
		
	_popOverController = pop ;
}

- (id) popOverController {
	
	return _popOverController;
}

@end
