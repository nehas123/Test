//
//  ViewController.m
//  Test
//
//  Created by Neha Salankar on 07/12/17.
//  Copyright © 2017 Neha Salankar. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()
{
    UITableView *tableview;
    NSArray *arrResponse;
    UIRefreshControl *refreshControl;
}
@end

@implementation ViewController
NSString *strUrl = @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json";
#define kTableViewCellHeight 44.0

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //To add tableview
    [self createTableView];
    
    //Call Web Service
    [self getWebData];
    
    //Refresh List
    [self pullToRefresh];
}
-(void) createTableView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.estimatedRowHeight = 44;
    tableview.rowHeight = UITableViewAutomaticDimension;
    
    //Constraints
    tableview.translatesAutoresizingMaskIntoConstraints = false;
    [[NSLayoutConstraint constraintWithItem: tableview
                                  attribute: NSLayoutAttributeLeading
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeLeading
                                 multiplier: 1
                                   constant: 0.0] setActive:true];
    
    [[NSLayoutConstraint constraintWithItem:tableview
                                  attribute: NSLayoutAttributeTop
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: self.view
                                  attribute: NSLayoutAttributeTop
                                 multiplier: 1
                                   constant: 0] setActive:true];
    
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:tableview
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:0
                                 toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:1.0
                                 constant:0];
    
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:tableview
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    
    [self.view addConstraint:width];
    [self.view addConstraint:height];
}
-(void) getWebData{
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = (NSDictionary *)responseObject;
        NSArray *responseArray = [responseDict valueForKey:@"rows"];
        arrResponse = [NSArray arrayWithArray:responseArray];
        self.title = [responseDict objectForKey:@"title"];
        [tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert];
    }];
    
    [operation start];
}
-(void) showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Retrieving data" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void) pullToRefresh{
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor lightGrayColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self
                       action:@selector(loadData)
             forControlEvents:UIControlEventValueChanged];
    [tableview addSubview:refreshControl];
}
-(void)loadData
{
    [tableview reloadData];
    [refreshControl endRefreshing];
}
#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrResponse.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *tableviewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(tableviewCell == nil){
        tableviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    tableviewCell.textLabel.numberOfLines = 0;
    if([[arrResponse objectAtIndex:indexPath.row] valueForKey:@"title"] != [NSNull null]){
        tableviewCell.textLabel.text = [[arrResponse objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    else{
        tableviewCell.textLabel.text = @"No title";
    }
    tableviewCell.detailTextLabel.numberOfLines = 0;
    
    if ([[arrResponse objectAtIndex:indexPath.row] valueForKey:@"description"] != [NSNull null]){
        tableviewCell.detailTextLabel.text = [[arrResponse objectAtIndex:indexPath.row] valueForKey:@"description"];
    }
    else{
        tableviewCell.detailTextLabel.text = @"No description";
    }
    
    if ([[arrResponse objectAtIndex:indexPath.row] valueForKey:@"imageHref"] != [NSNull null]) {
        
        __block UIImage *img;
        __block UIImageView *imageView1 = tableviewCell.imageView;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [[arrResponse objectAtIndex:indexPath.row] valueForKey:@"imageHref"]]]];
            
        dispatch_async(dispatch_get_main_queue(),^{
                
        [imageView1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[arrResponse objectAtIndex:indexPath.row] valueForKey:@"imageHref"]]]
                                  placeholderImage:[UIImage imageNamed:@"PlaceholderImg"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               tableviewCell.imageView.image= image;
                                           }
                                           failure:nil];
            });
        });
    }
    else{
        tableviewCell.imageView.image = [UIImage imageNamed:@"PlaceholderImg"];
    }
    return tableviewCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
