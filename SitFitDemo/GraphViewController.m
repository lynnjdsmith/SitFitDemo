
#import "GraphViewController.h"
#import "GraphView.h"
#import "AccelerometerFilter.h"
#import "SharedReading.h"

#define kUpdateFrequency	60.0
#define kLocalizedPause		NSLocalizedString(@"Pause","pause taking samples")
#define kLocalizedResume	NSLocalizedString(@"Resume","resume taking samples")

@interface GraphViewController() <NodeDeviceDelegate>
{
	AccelerometerFilter *filter;
	BOOL isPaused, useAdaptive;
}

@property (nonatomic, strong) IBOutlet GraphView *unfiltered;
@property (nonatomic, strong) IBOutlet GraphView *filtered;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pause;
@property (nonatomic, strong) IBOutlet UILabel *filterLabel;
@property (strong, nonatomic) NSArray *currentNodeDeviceList;
@property (nonatomic) BOOL deviceConnected;

- (IBAction)pauseOrResume:(id)sender;
- (IBAction)filterSelect:(id)sender;
- (IBAction)adaptiveSelect:(id)sender;

// Sets up a new filter. Since the filter's class matters and not a particular instance
// we just pass in the class and -changeFilter: will setup the proper filter.
- (void)changeFilter:(Class)filterClass;

@end

@implementation GraphViewController

@synthesize unfiltered, filtered, pause, filterLabel;


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];

	pause.possibleTitles = [NSSet setWithObjects:kLocalizedPause, kLocalizedResume, nil];
	isPaused = NO;
	useAdaptive = NO;
	[self changeFilter:[LowpassFilter class]];
	//[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
	//[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	[unfiltered setIsAccessibilityElement:YES];
	[unfiltered setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];

	[filtered setIsAccessibilityElement:YES];
	[filtered setAccessibilityLabel:NSLocalizedString(@"filteredGraph", @"")];
  
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeDeviceListUpdated:) name:kNodeDeviceListUpdate object:[VTNodeManager getInstance]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedThatNodeDeviceIsReady:) name:VTNodeDeviceIsReadyNotification object:[VTNodeManager getInstance]];
  
  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                 selector:@selector(refreshDevice) userInfo:nil repeats:NO];
  self.deviceConnected = false;
    
  [SharedReading sharedManager];  //Set up singleton class to share acc. readings across view controllers
    
}

-(void)refreshDevice {
    //NSLog(@"refreshDevice");
  if (!self.deviceConnected) {
    //NSLog(@"refreshDevice INNER");
    [VTNodeManager stopFindingDevices];
    [VTNodeManager startFindingDevices];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                 selector:@selector(refreshDevice) userInfo:nil repeats:NO];
  }
}

-(void) nodeDeviceListUpdated:(NSNotification *)notification {
  //NSLog(@"***** node Device List Updated *****");
  self.currentNodeDeviceList = [VTNodeManager allNodeDevices];
  if (self.currentNodeDeviceList.count == 1) {
    [VTNodeManager connectToDevice:self.currentNodeDeviceList[0]];
  }
}

- (void) notifiedThatNodeDeviceIsReady:(NSNotification *)notification
{
  NSLog(@"***** Node Device Is Ready *****");
  self.deviceConnected = true;
  [VTNodeManager getInstance].selectedNodeDevice.delegate = self;
  [[VTNodeManager getInstance].selectedNodeDevice setStreamModeAcc:YES Gyro:YES Mag:YES withTimestampingEnabled:YES];
    
    
  [[VTNodeManager getInstance].selectedNodeDevice requestBLEConnectionParamsUpdateWithMinConnInterval: 8 withMaxConnInterval:16 withSlaveLatency:0 withSupervisionTimeout:400];  //I think I'm requesting the fastest possible BLE connection settings here, as described in VTNodeDevice.h    Maybe not necessary... may not help with the lag
  
}

-(void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
  
  //Grab the Node delegate
  [VTNodeManager getInstance].selectedNodeDevice.delegate = self;
  [[VTNodeManager getInstance].selectedNodeDevice setStreamModeAcc:YES Gyro:YES Mag:YES withTimestampingEnabled:YES];
  
  //NSLog(@"appear!");
}

-(void) viewWillDisappear:(BOOL)animated {
  //Check if the back button was pressed
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
    //Stop streaming
    [[VTNodeManager getInstance].selectedNodeDevice setStreamModeAcc:NO Gyro:NO Mag:NO withTimestampingEnabled:NO];
  }
  [super viewWillDisappear:animated];
}

#pragma mark - NodeDeviceDelegate

-(void)nodeDeviceDidUpdateAccReading:(VTNodeDevice *)device withReading:(VTSensorReading *)reading {
  //static float accScaleMax = 16.0f;
    
  SharedReading *singletonRds = [SharedReading sharedManager];

  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:reading forKey:@"reading"];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:GraphViewMovementNotification object:nil userInfo: userInfo];

  [unfiltered addX:(reading.x*3) y:(reading.y*3) z:(reading.z*3)];  //multiply by 3 to fill the graph more 

  [singletonRds setX:reading.x];  //set readings in the singleton which are directly visible to other objects
  [singletonRds setY:reading.y];  //like BodyViewController
}

// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	// Update the accelerometer graph view
	if (!isPaused)
	{
		//[filter addAcceleration:acceleration];
		//[unfiltered addX:acceleration.x y:acceleration.y z:acceleration.z];
		//[filtered addX:filter.x y:filter.y z:filter.z];
	}
}

- (void)changeFilter:(Class)filterClass
{
	// Ensure that the new filter class is different from the current one...
	if (filterClass != [filter class])
	{
		// And if it is, release the old one and create a new one.
		filter = [[filterClass alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:5.0];
		// Set the adaptive flag
		filter.adaptive = useAdaptive;
		// And update the filterLabel with the new filter name.
		// LYNN filterLabel.text = filter.name;
	}
}

- (IBAction)pauseOrResume:(id)sender
{
	if (isPaused)
	{
		// If we're paused, then resume and set the title to "Pause"
		isPaused = NO;
		pause.title = kLocalizedPause;
	}
	else
	{
		// If we are not paused, then pause and set the title to "Resume"
		isPaused = YES;
		pause.title = kLocalizedResume;
	}
	
	// Inform accessibility clients that the pause/resume button has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (IBAction)filterSelect:(id)sender
{
	if ([sender selectedSegmentIndex] == 0)
	{
		// Index 0 of the segment selects the lowpass filter
		[self changeFilter:[LowpassFilter class]];
	}
	else
	{
		// Index 1 of the segment selects the highpass filter
		[self changeFilter:[HighpassFilter class]];
	}

	// Inform accessibility clients that the filter has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (IBAction)adaptiveSelect:(id)sender
{
	// Index 1 is to use the adaptive filter, so if selected then set useAdaptive appropriately
	useAdaptive = [sender selectedSegmentIndex] == 1;
	// and update our filter and filterLabel
	filter.adaptive = useAdaptive;
	// LYNN filterLabel.text = filter.name;
	
	// Inform accessibility clients that the adaptive selection has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (void)putValues {
  NSLog(@"PUTTING VALUES");
}

@end
