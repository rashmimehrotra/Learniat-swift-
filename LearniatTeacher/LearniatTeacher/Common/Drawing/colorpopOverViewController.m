//
//  colorpopOverViewController.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "colorpopOverViewController.h"

@interface colorpopOverViewController ()

@end

@implementation colorpopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // By Ujjval
        // Initialize array with colors array
        // ==========================================
        
        _colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],[UIColor colorWithRed:121.0/255.0 green:11.0/255.0 blue:29.0/255.0 alpha:1.0],[UIColor colorWithRed:52.0/255.0 green:3.0/255.0 blue:11.0/255.0 alpha:1.0],[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],[UIColor colorWithRed:243.0/255.0 green:157.0/255.0 blue:171.0/255.0 alpha:1.0],[UIColor colorWithRed:247.0/255.0 green:49.0/255.0 blue:237.0/255.0 alpha:1.0],[UIColor colorWithRed:86.0/255.0 green:3.0/255.0 blue:82.0/255.0 alpha:1.0],[UIColor colorWithRed:116.0/255.0 green:30.0/255.0 blue:236.0/255.0 alpha:1.0],[UIColor colorWithRed:122.0/255.0 green:118.0/255.0 blue:250.0/255.0 alpha:1.0],[UIColor colorWithRed:7.0/255.0 green:1.0/255.0 blue:181.0/255.0 alpha:1.0],[UIColor colorWithRed:4.0/255.0 green:1.0/255.0 blue:76.0/255.0 alpha:1.0],[UIColor colorWithRed:16.0/255.0 green:196.0/255.0 blue:236.0/255.0 alpha:1.0],[UIColor colorWithRed:2.0/255.0 green:77.0/255.0 blue:94.0/255.0 alpha:1.0],[UIColor colorWithRed:98.0/255.0 green:251.0/255.0 blue:154.0/255.0 alpha:1.0],[UIColor colorWithRed:7.0/255.0 green:148.0/255.0 blue:30.0/255.0 alpha:1.0],[UIColor colorWithRed:2.0/255.0 green:68.0/255.0 blue:13.0/255.0 alpha:1.0],[UIColor colorWithRed:94.0/255.0 green:101.0/255.0 blue:9.0/255.0 alpha:1.0],[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:250.0/255.0 green:107.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:71.0/255.0 green:107.0/255.0 blue:5.0/255.0 alpha:1.0],[UIColor colorWithRed:95.0/255.0 green:101.0/255.0 blue:92.0/255.0 alpha:1.0], nil];
        
        // ==========================================
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(10, 135, 380, 1)];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] CGColor];
    [self.view addSubview:view];
    colorButtonArray=[[NSMutableArray alloc] init];
    
    int Counter=0;
    float slidervalue=0;
    int selecteColorButton = 0;
    if (selectedtab==1)
    {
       selecteColorButton=  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedBrushColor"];
        slidervalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"selectedBrushsize"];

    }
    else if(selectedtab==3)
    {
        
        selecteColorButton=  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTextColor"];
        slidervalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"selectedtextSize"];
    }
    else
    {
        selecteColorButton=4;
        slidervalue = [[NSUserDefaults standardUserDefaults] floatForKey:@"selectedEraserSize"];

    }
    
    
    
    if (slidervalue<=0)
    {
        slidervalue=6;
    }
    
    
    
    
    
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_7_1)
    {
        UISlider *progressbar = [[UISlider alloc]initWithFrame:CGRectMake(15, 40, [self rect].size.width-30,10)];
        [self.view addSubview:progressbar];
        progressbar.tintColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0];
        progressbar.maximumValue = 40;
        [progressbar setValue:slidervalue];
        [progressbar addTarget:self action:@selector(onprogressBarValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(([self rect].size.width-70)/2.0, 70, 100, 24)];
        fontLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        fontLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        [self.view addSubview:fontLabel];
        [fontLabel setText:[NSString stringWithFormat:@"%d",(int)slidervalue]];
    }
    else
    {
        UISlider *progressbar = [[UISlider alloc]initWithFrame:CGRectMake(15, 70, [self rect].size.width-30,30)];
        [self.view addSubview:progressbar];
        progressbar.tintColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0];
        progressbar.maximumValue = 40;
        [progressbar setValue:slidervalue];
        [progressbar addTarget:self action:@selector(onprogressBarValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressbar.center.x-50, 100, 100, 24)];
        fontLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        fontLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        [self.view addSubview:fontLabel];
        [fontLabel setText:[NSString stringWithFormat:@"%d points",(int)slidervalue]];
        [fontLabel setTextAlignment:NSTextAlignmentCenter];
    }
    

    
    
    
    
    
    
    
    
    
    
    
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<7;j++)
        {
            Counter++;
            
            UIButton *circleView = [[UIButton alloc] initWithFrame:CGRectMake(55*j+15,55*i+180,35,35)];
            circleView.alpha = 0.6;
            circleView.layer.cornerRadius = 17.50;
            // By Ujjval
            // ==========================================
            
            if(Counter<23)
                circleView.backgroundColor = [_colorArray objectAtIndex:Counter-1];
            
            // ==========================================
            [self.view addSubview:circleView];
            [circleView addTarget:self action:@selector(onColorSelectbutton:) forControlEvents:UIControlEventTouchUpInside];
            [circleView setTag:Counter];
            [colorButtonArray addObject:circleView];
            if(Counter==selecteColorButton)
            {
                
                [circleView setImage:[UIImage imageNamed:@"Tick_mark_image"] forState:UIControlStateNormal];
            }
            
        }
    }
    
    

    
    
}
-(void) setSelectTab:(int)tabTag
{
    selectedtab=tabTag;
}

- (void)onColorSelectbutton:(id)sender
{
    
    
    
    for (int i=0; i<[colorButtonArray count]; i++)
    {
        UIButton *button2=(UIButton *)[colorButtonArray objectAtIndex:i] ;
        if (i!=button2.tag)
        {
            [button2 setImage:nil forState:UIControlStateNormal];
        }

    }
    
    UIButton *button = (UIButton*)sender;
    [button setImage:[UIImage imageNamed:@"Tick_mark_image"] forState:UIControlStateNormal];
    
    if (selectedtab==1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:button.tag forKey:@"selectedBrushColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(selectedtab==3)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:button.tag forKey:@"selectedTextColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // By Ujjval
    // ==========================================
    
    [[self delegate] selectedColor:[_colorArray objectAtIndex:button.tag-1] withSelectedTab:selectedtab];
    
    // ==========================================
    
    [[self popOverController]dismissPopoverAnimated:true];
    

}
- (void)onprogressBarValueChanged:(id)sender
{
    
    UISlider* progressView= (UISlider*)sender;
    
    [[self delegate] selectedbrushSize:sender withSelectedTab:selectedtab];
    
    if (selectedtab==1)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:progressView.value forKey:@"selectedBrushsize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(selectedtab==2)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:progressView.value forKey:@"selectedEraserSize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setFloat:progressView.value forKey:@"selectedtextSize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    int x = progressView.value;
    [fontLabel setText:[NSString stringWithFormat:@"%d points",x]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setPopOverController:(id) pop {
	
    
	_popOverController = pop;
}

- (id) popOverController {
	
	return _popOverController;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
