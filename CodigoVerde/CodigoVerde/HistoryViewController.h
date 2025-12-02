//
//  HistoryViewController.h
//  CodigoVerde
//
//  Created by Guest User on 28/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Agregamos los delegados para poder controlar la colección
@interface HistoryViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
