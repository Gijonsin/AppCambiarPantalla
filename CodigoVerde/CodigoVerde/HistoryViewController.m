//
//  HistoryViewController.m
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import "HistoryViewController.h"
#import "DataManager.h"
#import "HistoryCell.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Le decimos a la colección: "Yo soy tu jefe (delegate) y tu proveedor de datos (dataSource)"
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Cada vez que entres a esta pantalla, recarga los datos por si agregaste algo nuevo
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource

// 1. ¿Cuántos elementos vamos a mostrar?
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Tantos como haya en el historial del DataManager
    return [DataManager sharedManager].activityHistory.count;
}

// 2. ¿Qué poner en cada celda?
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Pedimos una celda reciclable usando el ID que pusimos en el Storyboard
    HistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"historyCellId" forIndexPath:indexPath];
    
    // Obtenemos los datos de la fila correspondiente (ojo, el historial puede estar al revés, esto obtiene el índice 0, 1, 2...)
    // Si quieres que el más reciente salga primero, usa: .count - 1 - indexPath.row
    NSDictionary *data = [DataManager sharedManager].activityHistory[indexPath.row];
    
    // Configurar la celda con los datos reales
    
    // Formatear la fecha para que se vea bonita
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [formatter stringFromDate:data[@"date"]];
    
    cell.lblDate.text = [NSString stringWithFormat:@"Date: %@", dateString];
    cell.lblType.text = [NSString stringWithFormat:@"Activity: %@", [data[@"type"] capitalizedString]];
    cell.lblAmount.text = [NSString stringWithFormat:@"Amount: %.1f", [data[@"amount"] doubleValue]];
    cell.lblCo2.text = [NSString stringWithFormat:@"Saving: %.2f Kg CO₂", [data[@"co2"] doubleValue]];
    
    // Un poco de diseño (bordes redondeados para que parezca tarjeta)
    cell.layer.cornerRadius = 10;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return cell;
}


@end
