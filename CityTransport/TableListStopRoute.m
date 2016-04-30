//
//  TableListStopRoute.m
//  CityTransport
//
//  Created by Nikolay on 27.04.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "TableListStopRoute.h"
#import "TableListStopsViewController.h"
#import "TableListStopRouteCell.h"

@interface TableListStopRoute ()

@property (strong, nonatomic) TableListStopRouteCell *cell;
@property (strong, nonatomic) UIActivityIndicatorView *initialActivityIndicator;

@property (strong, nonatomic) URLListStopRouteObject *krasnodarObjects;
@property (strong, nonatomic) NSMutableArray *stopRouteList;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;

@end

static NSString *CellIdentifier = @"CellStopRoute";

static NSString* urlListStopRoute = @"http://mobileapps.krd.ru:9000/api/v2/db/routes?stopId=";


@implementation TableListStopRoute

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self routeFundraisingData];

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
    return [self.stopRouteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    self.krasnodarObjects = [self.stopRouteList objectAtIndex:indexPath.row];
    self.cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSString *numberRoute = [NSString stringWithFormat:@"%@", self.krasnodarObjects.krasnodarShortName];

    self.cell.numberShort.text = numberRoute;
    
    self.cell.nameStopRoute.text = self.krasnodarObjects.krasnodarName;    
    
    return self.cell;
}

-(void)routeFundraisingData
{
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", urlListStopRoute, self.recievedFundraisingObject.krasnodarId];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL:[NSURL URLWithString:fullURL]
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
                                    URLListStopRouteObject *listStopsRouteObject =
                                    [[URLListStopRouteObject alloc] initWithKrasnodarShortName:dictionary[@"shortName"]
                                                                       KrasnodarName:dictionary[@"name"]];
                                    
                                    [krasnodarObjectsCollected addObject:listStopsRouteObject];
                                }
                                
                                self.stopRouteList = krasnodarObjectsCollected;
                                
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
