//
//  ActivityLogViewController.m
//  CodigoVerde
//
//  Created by Guest User on 01/12/25.
//

#import "ActivityLogViewController.h"

@interface ActivityLogViewController ()

@end

@implementation ActivityLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Le damos estilo a la etiqueta (bordes redondeados, opcional)
    self.lblTips.layer.cornerRadius = 10;
    self.lblTips.layer.masksToBounds = YES;
    
    // Mostramos un tip inicial
    [self showRandomTip];
}

// Opcional: Cambiar el tip cada vez que entras a la pantalla
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showRandomTip];
}

- (void)showRandomTip {
    NSArray *tips = @[
        @"💡 Use natural light: Open curtains and turn off lights during the day.",
                @"💧 Quick shower: Reducing your shower by 2 minutes saves up to 40 liters of water.",
                @"🚗 Efficient driving: Avoid sudden acceleration to save fuel.",
                @"♻️ Separate correctly: Wash containers before recycling them.",
                @"🥩 Meatless Monday: Reducing meat consumption significantly lowers your footprint.",
                @"🛍️ Reusable bags: Always bring your own bag to the market.",
                @"🔌 Energy vampires: Unplug chargers you are not using.",
                @"🌡️ Air conditioning: Set it to 24°C; every extra degree uses 8% more energy."
    ];
    
    // Elegir un índice al azar
    int randomIndex = arc4random_uniform((uint32_t)tips.count);
    
    // Asignar el texto
    self.lblTips.text = tips[randomIndex];
}

@end
