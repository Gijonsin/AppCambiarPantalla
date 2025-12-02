//
//  DataManager.m
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        // --- AQUÍ EMPIEZA LA MAGIA DE LA PERSISTENCIA (CARGAR) ---
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // 1. Recuperar el total de CO2
        sharedInstance.totalCo2 = [defaults doubleForKey:@"totalCo2"];
        
        // 2. Recuperar el historial
        // (NSUserDefaults devuelve un Array normal, necesitamos convertirlo a Mutable para poder agregarle cosas después)
        NSArray *savedHistory = [defaults objectForKey:@"activityHistory"];
        
        if (savedHistory) {
            sharedInstance.activityHistory = [savedHistory mutableCopy];
            
            // ORDENAR AL CARGAR (Más reciente primero) ---
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
            [sharedInstance.activityHistory sortUsingDescriptors:@[sortDescriptor]];
        } else {
            // Si es la primera vez que se usa la app, creamos una lista vacía
            sharedInstance.activityHistory = [[NSMutableArray alloc] init];
        }
        
        //Verificar y cargar retos
        [sharedInstance checkAndRefreshChallenges];
        
        NSLog(@"Datos cargados. Total CO2: %.2f | Entradas: %lu", sharedInstance.totalCo2, (unsigned long)sharedInstance.activityHistory.count);
    });
    return sharedInstance;
}

- (void)addActivityType:(NSString *)type amount:(double)amount date:(NSDate *)date {
    double co2Saved = 0.0;

    // Fórmulas aproximadas (puedes ajustarlas)
    if ([type isEqualToString:@"recycling"]) {
        co2Saved = amount * 2.5; // 1kg reciclaje = 2.5kg CO2
    } else if ([type isEqualToString:@"energy"]) {
        co2Saved = amount * 0.5; // 1kWh energía = 0.5kg CO2
    } else if ([type isEqualToString:@"water"]) {
        co2Saved = amount * 0.2; // 1L agua = 0.2kg CO2
    } else if ([type isEqualToString:@"transport"]) {
        co2Saved = amount * 0.15; // 1km transporte eco = 0.15kg CO2
    }
    
    // 1. Sumar al total global
    self.totalCo2 += co2Saved;
    
    // 2. Crear el registro para el historial
    NSDictionary *entry = @{
        @"type": type,
        @"amount": @(amount),
        @"date": date,
        @"co2": @(co2Saved)
    };
    
    // Guardarlo en la lista
    [self.activityHistory addObject:entry];
    
    // --- ORDENAR INMEDIATAMENTE ---
    // ascending:NO hace que la fecha más nueva quede en el índice 0 (arriba)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [self.activityHistory sortUsingDescriptors:@[sortDescriptor]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    // Guardamos el número total
    [defaults setDouble:self.totalCo2 forKey:@"totalCo2"];
        
    // Guardamos la lista completa
    [defaults setObject:self.activityHistory forKey:@"activityHistory"];
        
    // Forzamos el guardado inmediato (opcional en iOS modernos, pero buena práctica para aprender)
    [defaults synchronize];
        
    NSLog(@"Datos guardados permanentemente.");
}

- (double)getCo2ForToday {
    double totalToday = 0.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 1. Sumar Actividades del Historial
        for (NSDictionary *entry in self.activityHistory) {
            NSDate *entryDate = entry[@"date"];
            if ([calendar isDateInToday:entryDate]) {
                totalToday += [entry[@"co2"] doubleValue];
            }
        }
        
        // 2. Sumar Desafíos DIARIOS completados
        // Recorremos la lista de retos diarios y si tienen check, sumamos su premio
        for (NSDictionary *challenge in self.dailyChallenges) {
            if ([challenge[@"completed"] boolValue]) {
                totalToday += [challenge[@"reward"] doubleValue];
            }
        }
    return totalToday;
}

- (double)getCo2ForThisWeek {
    double totalWeek = 0.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSInteger currentWeek = [calendar component:NSCalendarUnitWeekOfYear fromDate:now];
    
    // 1. Sumar Actividades de la Semana (Lo que ya hacía)
    for (NSDictionary *entry in self.activityHistory) {
        NSDate *entryDate = entry[@"date"];
        NSInteger entryWeek = [calendar component:NSCalendarUnitWeekOfYear fromDate:entryDate];
        
        if (currentWeek == entryWeek) {
            totalWeek += [entry[@"co2"] doubleValue];
        }
    }
    
    // 2. NUEVO: Sumar Desafíos DIARIOS completados (también cuentan para la semana)
    for (NSDictionary *challenge in self.dailyChallenges) {
        if ([challenge[@"completed"] boolValue]) {
            totalWeek += [challenge[@"reward"] doubleValue];
        }
    }
    
    // 3. NUEVO: Sumar Desafíos SEMANALES completados
    for (NSDictionary *challenge in self.weeklyChallenges) {
        if ([challenge[@"completed"] boolValue]) {
            totalWeek += [challenge[@"reward"] doubleValue];
        }
    }
    
    return totalWeek;
}

// Método para generar retos diarios
- (NSArray *)generateDailyChallenges {
    return @[
        [@{ @"title": @"Use a reusable water bottle", @"completed": @NO, @"reward": @2.0 } mutableCopy],
        [@{ @"title": @"Turn the lights off for 1 h", @"completed": @NO, @"reward": @1.5 } mutableCopy],
        [@{ @"title": @"Recycle a bottle", @"completed": @NO, @"reward": @3.0 } mutableCopy]
    ];
}

// Método para generar retos semanales
- (NSArray *)generateWeeklyChallenges {
    return @[
        [@{ @"title": @"Go meatless for 2 days", @"completed": @NO, @"reward": @10.0 } mutableCopy],
        [@{ @"title": @"Walk 10 kilometers", @"completed": @NO, @"reward": @15.0 } mutableCopy],
        [@{ @"title": @"Plant a tree", @"completed": @NO, @"reward": @20.0 } mutableCopy]
    ];
}

- (void)checkAndRefreshChallenges {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastDailyDate = [defaults objectForKey:@"lastDailyUpdate"];
    
    // Si no hay fecha guardada o NO es hoy, reseteamos los diarios
    if (!lastDailyDate || ![[NSCalendar currentCalendar] isDateInToday:lastDailyDate]) {
        self.dailyChallenges = [[self generateDailyChallenges] mutableCopy];
        [defaults setObject:[NSDate date] forKey:@"lastDailyUpdate"]; // Guardamos "hoy" como última vez
        [defaults setObject:self.dailyChallenges forKey:@"dailyChallenges"]; // Guardamos la lista nueva
    } else {
        // Si es el mismo día, cargamos los que ya teníamos (para no perder los checks)
        self.dailyChallenges = [[defaults objectForKey:@"dailyChallenges"] mutableCopy];
    }
    
    // Hacemos lo mismo para los semanales (simplificado: si pasaron 7 días o no existe)
    // Para este proyecto escolar, podemos usar la misma lógica diaria o una simple validación si existen
    if (![defaults objectForKey:@"weeklyChallenges"]) {
        self.weeklyChallenges = [[self generateWeeklyChallenges] mutableCopy];
        [defaults setObject:self.weeklyChallenges forKey:@"weeklyChallenges"];
    } else {
        self.weeklyChallenges = [[defaults objectForKey:@"weeklyChallenges"] mutableCopy];
    }
    
    [defaults synchronize];
}

- (void)completeChallenge:(int)index type:(NSString *)type {
    NSMutableArray *targetList;
    NSString *key;
    
    if ([type isEqualToString:@"daily"]) {
        targetList = self.dailyChallenges;
        key = @"dailyChallenges";
    } else {
        targetList = self.weeklyChallenges;
        key = @"weeklyChallenges";
    }
    
    // Obtener el reto
    NSMutableDictionary *challenge = [targetList[index] mutableCopy];
    BOOL isNowCompleted = ![challenge[@"completed"] boolValue]; // Invertir estado (Toggle)
    
    // Guardar nuevo estado
    challenge[@"completed"] = @(isNowCompleted);
    targetList[index] = challenge;
    
    // --- RECOMPENSA EN EL PROGRESO ---
    double reward = [challenge[@"reward"] doubleValue];
    if (isNowCompleted) {
        self.totalCo2 += reward; // Sumar al total si se completa
    } else {
        self.totalCo2 -= reward; // Restar si se desmarca (se arrepintió)
    }
    
    // Guardar todo en persistencia
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:targetList forKey:key];
    [defaults setDouble:self.totalCo2 forKey:@"totalCo2"]; // Guardar el nuevo total
    [defaults synchronize];
}

@end
