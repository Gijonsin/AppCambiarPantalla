//
//  TransportViewController.m
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import "TransportViewController.h"
#import "DataManager.h"
@interface TransportViewController ()

@end

@implementation TransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnSaveTapped:(id)sender {
    double amount = [self.txtAmount.text doubleValue];
    
    // Capturamos la fecha del DatePicker
    NSDate *selectedDate = self.datePicker.date;
    
    if (amount > 0) {
        // Enviamos la fecha al cerebro
        [[DataManager sharedManager] addActivityType:@"transport" amount:amount date:selectedDate];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
