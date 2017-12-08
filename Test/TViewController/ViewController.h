//
//  ViewController.h
//  Test
//
//  Created by Neha Salankar on 07/12/17.
//  Copyright © 2017 Neha Salankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *navBarTitle;
-(void) getWebDataWithUrlString:(NSString *)urlString completionHandler:(void(^)(bool))isComplete;
@end

