//
//  DashBoardViewController.m
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import "DashBoardViewController.h"
#import "DataManager.h"
@interface DashBoardViewController ()

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DataManager *data = [DataManager sharedManager];
    // 1. Definimos la Meta Global (Ejemplo: 100 Kg para empezar)
    double metaGlobal = 100.0;
    double totalActual = data.totalCo2;
    double faltante = metaGlobal - totalActual;
    // --- LÓGICA DE LA META GENERAL ---
        
    
    // Actualizar el total
    self.lblTotalCo2.text = [NSString stringWithFormat:@"Total amount: %.2f Kg of CO₂", data.totalCo2];
    
    // Mostramos cuánto falta
        if (faltante > 0) {
            self.lblRemaining.text = [NSString stringWithFormat:@"%.2f Kg to goal %.0f Kg", faltante, metaGlobal];
            self.lblRemaining.textColor = [UIColor darkGrayColor];
        } else {
            self.lblRemaining.text = @"¡Congrats you have achieve the goal! 🎉";
            self.lblRemaining.textColor = [UIColor systemGreenColor];
        }
    
    // --- METAS (Valores ejemplo, puedes cambiarlos) ---
    double metaDiaria = 10.0;  // Meta: Ahorrar 10kg al día
    double metaSemanal = 70.0; // Meta: Ahorrar 70kg a la semana
    
    // 2. Calcular progreso DIARIO
    double hoy = [data getCo2ForToday];
    float porcentajeDia = hoy / metaDiaria;
    
    // Actualizar barra y texto diario
    [self.progressDaily setProgress:porcentajeDia animated:NO];
    self.lblDailyAmount.text = [NSString stringWithFormat:@"%.1f / %.0f Kg", hoy, metaDiaria];
    
    // 3. Calcular progreso SEMANAL
    double semana = [data getCo2ForThisWeek];
    float porcentajeSemana = semana / metaSemanal;
    
    // Actualizar barra y texto semanal
    [self.progressWeekly setProgress:porcentajeSemana animated:NO];
    self.lblWeeklyAmount.text = [NSString stringWithFormat:@"%.1f / %.0f Kg", semana, metaSemanal];
}

@end
