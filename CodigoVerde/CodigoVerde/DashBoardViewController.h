//
//  DashBoardViewController.h
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashBoardViewController : UIViewController

// 1. Etiqueta para el Total Acumulado
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCo2;

// 2. Etiqueta para lo que falta para la Meta Global (Nueva)
@property (weak, nonatomic) IBOutlet UILabel *lblRemaining;
// Nuevos Outlets para las barras y etiquetas de progreso
@property (weak, nonatomic) IBOutlet UIProgressView *progressDaily;
@property (weak, nonatomic) IBOutlet UIProgressView *progressWeekly;
@property (weak, nonatomic) IBOutlet UILabel *lblDailyAmount;  // Para poner el texto "X Kg / Meta"
@property (weak, nonatomic) IBOutlet UILabel *lblWeeklyAmount;

@end

NS_ASSUME_NONNULL_END
