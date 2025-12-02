//
//  WaterViewController.h
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

// Action para el botón de guardar
- (IBAction)btnSaveTapped:(id)sender;


@end

NS_ASSUME_NONNULL_END
