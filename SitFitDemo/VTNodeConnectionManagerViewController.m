//
//  VTNodeConnectionManagerViewController.m
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import "VTNodeConnectionManagerViewController.h"

@interface VTNodeConnectionManagerViewController () <NodeDeviceDelegate>
@property (strong, nonatomic) NSArray *currentNodeDeviceList;
@end

@implementation VTNodeConnectionManagerViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeDeviceListUpdated:) name:kNodeDeviceListUpdate object:[VTNodeManager getInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedThatNodeDeviceIsReady:) name:VTNodeDeviceIsReadyNotification object:[VTNodeManager getInstance]];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
              action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
  
     NSLog(@"VIEW DID LOAD VTNODECONNMANAGERVC");
    [delegate sayHello];
  
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    //Grab the Node delegate
    [VTNodeManager getInstance].selectedNodeDevice.delegate = self;
    if([[VTNodeManager getInstance].selectedNodeDevice.peripheral isConnected]) {
        [VTNodeManager disconnectFromDevice:[VTNodeManager getInstance].selectedNodeDevice.peripheral];
        [VTNodeManager getInstance].selectedNodeDevice = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) nodeDeviceListUpdated:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.currentNodeDeviceList = [VTNodeManager allNodeDevices];
    return [self.currentNodeDeviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"nodeDeviceCell";
    VTNodeDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[VTNodeDeviceCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    
    cell.cbperipheral = [self.currentNodeDeviceList objectAtIndex:indexPath.row];
  
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VTNodeDeviceCell *cell = (VTNodeDeviceCell *)[tableView cellForRowAtIndexPath:indexPath];
    CBPeripheral *selectedDevice = cell.cbperipheral;
    [VTNodeManager connectToDevice:selectedDevice];

}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing device list..."];
    [VTNodeManager stopFindingDevices];
    [VTNodeManager startFindingDevices];
    [self.tableView reloadData];
    
    [refresh endRefreshing];
}

- (void) notifiedThatNodeDeviceIsReady:(NSNotification *)notification
{
    NSLog(@"notifiedThatNodeDeviceIsReady");
    //[self performSegueWithIdentifier:@"deviceSelectedSegue" sender:self];
}

#pragma mark - NodeDeviceDelegate

- (void) nodeDeviceIsReadyForCommunication:(VTNodeDevice *)device {
   //This is handled by notification from the Connection Manager
}

-(void)nodeDeviceFailedToInit:(VTNodeDevice *)device {
    //This is handled by notification from the Connection Manager
}

@end
