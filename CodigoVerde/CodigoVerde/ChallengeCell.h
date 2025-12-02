//
//  ChallengeCell.h
//  CodigoVerde
//
//  Created by Guest User on 01/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChallengeCell : UITableViewCell

// 1. Outlet para el texto del desafío
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

// 2. Outlet para el selector (Completed / In Progress)
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentStatus;

// 3. El "Chismoso" (Callback): Un bloque de código que avisará al ViewController cuando cambien el estado
@property (nonatomic, copy) void (^statusChangedBlock)(BOOL isCompleted);

@end

NS_ASSUME_NONNULL_END
