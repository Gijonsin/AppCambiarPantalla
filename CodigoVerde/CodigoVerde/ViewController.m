//  ViewController.m
//  CodigoVerde
//  Created by Guest User on 27/11/25.
#import "ViewController.h"
#import "DataManager.h"
#import "ChallengeCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Le decimos a la tabla: "Yo te controlo (delegate) y yo te doy los datos (dataSource)"
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1. Verificar si es un nuevo día para generar nuevos retos
    [[DataManager sharedManager] checkAndRefreshChallenges];
    
    // 2. Recargar la tabla para mostrar los datos frescos
    [self.tableView reloadData];
}

// Queremos 2 secciones: una para Diarios y otra para Semanales
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Ponerle título bonito a cada sección
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Daily Challenges (Gain +2 Kg CO₂)";
    } else {
        return @"Weekly Challenges (Gain +10 Kg CO₂)";
    }
}

// Decirle a la tabla cuántas filas tiene cada sección
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DataManager *data = [DataManager sharedManager];
    
    if (section == 0) {
        return data.dailyChallenges.count; // Sección 0 = Diarios
    } else {
        return data.weeklyChallenges.count; // Sección 1 = Semanales
    }
}

// Configurar cada celda individualmente
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. Pedir una celda reutilizable (Asegúrate que el ID en Storyboard sea "challengeCellId")
    ChallengeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeCellId"];
    
    // 2. Obtener el dato correcto del Cerebro
    DataManager *data = [DataManager sharedManager];
    NSDictionary *challenge;
    NSString *challengeType;
    
    if (indexPath.section == 0) {
        challenge = data.dailyChallenges[indexPath.row];
        challengeType = @"daily";
    } else {
        challenge = data.weeklyChallenges[indexPath.row];
        challengeType = @"weekly";
    }
    
    // 3. Llenar la celda con la información
    cell.lblTitle.text = challenge[@"title"];
    
    // Configurar el Segmented Control (0 = Completado, 1 = En Progreso)
    BOOL isCompleted = [challenge[@"completed"] boolValue];
    cell.segmentStatus.selectedSegmentIndex = isCompleted ? 0 : 1;
    
    // Cambiar el color del texto si está completado (detallito visual)
    if (isCompleted) {
        cell.lblTitle.textColor = [UIColor systemGreenColor];
    } else {
        cell.lblTitle.textColor = [UIColor labelColor]; // Color negro normal
    }
    
    // 4. Lógica del Botón (Callback)
    // Esto se ejecuta cuando el usuario toca el segmento en la celda
    __weak typeof(self) weakSelf = self;
    cell.statusChangedBlock = ^(BOOL completed) {
        
        // Avisar al cerebro para que guarde y sume puntos
        [[DataManager sharedManager] completeChallenge:(int)indexPath.row type:challengeType];
        
        // Recargar la tabla para ver cambios visuales (como el color del texto)
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

// Este método le dice a la tabla cuánto debe medir de alto cada fila
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Le daremos 100 puntos de altura (ajusta este número si las quieres más grandes o chicas)
    return 100.0;
}

@end
