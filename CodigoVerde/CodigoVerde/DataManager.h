//
//  DataManager.h
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

// Propiedad para guardar el total de CO2 ahorrado (o emitido)
@property (nonatomic, assign) double totalCo2;

@property (nonatomic, strong) NSMutableArray *activityHistory; // pars el historial


@property (nonatomic, strong) NSMutableArray *dailyChallenges;
@property (nonatomic, strong) NSMutableArray *weeklyChallenges;

// Método para obtener la instancia compartida (el Singleton)
+ (instancetype)sharedManager;

// Método para registrar una actividad
// type: "recycling", "energy", etc.
// amount: la cantidad (kg, kWh, etc.)
- (void)addActivityType:(NSString *)type amount:(double)amount date:(NSDate *)date;

// Métodos para obtener sumas filtradas por tiempo
- (double)getCo2ForToday;
- (double)getCo2ForThisWeek;

// Método para generar/resetear retos si cambió el día
- (void)checkAndRefreshChallenges;

// Método para marcar un reto (saber si es diario o semanal por el tipo)
- (void)completeChallenge:(int)index type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
