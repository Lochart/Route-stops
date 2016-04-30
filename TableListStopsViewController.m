//
//  TableListStopsViewController.m
//  CityTransport
//
//  Created by Nikolay on 19.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "TableListStopsViewController.h"
#import "URLListStropsObject.h"

@interface TableListStopsViewController ()

@property (strong, nonatomic) URLListStropsObject *krasnodarObject;
@property (strong, nonatomic) NSMutableArray *stopsList;

@property (strong, nonatomic) TableListStopsViewCell *cell;
@property (strong, nonatomic) UIActivityIndicatorView *initialActivityIndicator;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;


@end

static NSString *CellIdentifier = @"CellStops";

static NSString* urlListStops = @"http://mobileapps.krd.ru:9000/api/v2/db/stops";

@implementation TableListStopsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self fetchFundraisingData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.stopsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.krasnodarObject = [self.stopsList objectAtIndex:indexPath.row];
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.cell.nameStops.text = self.krasnodarObject.krasnodarName;
    
    return self.cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"UpdateDevice"]){
        
        URLListStropsObject *selectedFundraisingObject  = [self.stopsList objectAtIndex:[[self.tableView
                                                                        indexPathForSelectedRow]row]];
        
        TableListStopRoute *detailViewController = segue.destinationViewController;
        detailViewController.recievedFundraisingObject = selectedFundraisingObject;

    }
}

-(void)fetchFundraisingData
{
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:[NSURL URLWithString:urlListStops]
                completionHandler:^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
                    if(!error){
                        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                        if(urlResponse.statusCode == 200){
                            NSError *jsonError;
                            NSDictionary *responseObject =
                            [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
                            
                            NSMutableArray *krasnodarObjectsCollected = [[NSMutableArray alloc] init];
                            if(!jsonError){
                                NSArray *loansArrayContents = responseObject[@"data"];
                                for(NSDictionary *dictionary in loansArrayContents){
                                    URLListStropsObject *listStopsObject =
                                    [[URLListStropsObject alloc] initWithKrasnodarId:dictionary[@"id"]
                                                                        KrasnodarName:dictionary[@"name"]];
                                
                                    [krasnodarObjectsCollected addObject:listStopsObject];
                                     }
                                
                                self.stopsList = krasnodarObjectsCollected;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                    if([self.refreshControl isRefreshing]){
                                        [self.refreshControl endRefreshing];
                                    } else {
                                        if([self.initialActivityIndicator isDescendantOfView:self.view]){
                                            [self.initialActivityIndicator stopAnimating];
                                            [self.initialActivityIndicator removeFromSuperview];
                                            self.tableView.separatorStyle =
                                            UITableViewCellSeparatorStyleSingleLine;
                                        }
                                    }
                                    [self.tableView reloadData];
                                });
                            }
                        }
                    }
                }];
        [dataTask resume];
}

@end
