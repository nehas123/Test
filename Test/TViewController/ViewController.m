//
//  ViewController.m
//  Test
//
//  Created by Neha Salankar on 07/12/17.
//  Copyright © 2017 Neha Salankar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UITableView *tableview;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //To add tableview
    [self createTableView];

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

#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *tableviewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(tableviewCell == nil){
        tableviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    tableviewCell.textLabel.text = @"test";
    return tableviewCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
