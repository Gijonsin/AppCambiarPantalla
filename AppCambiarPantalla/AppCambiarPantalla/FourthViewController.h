//
//  FourthViewController.h
//  AppCambiarPantalla
//
//  Created by Guest User on 05/12/25.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FourthViewController : UIViewController

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *miImageView;
@property (weak, nonatomic) IBOutlet UILabel *miLabel;
@end

NS_ASSUME_NONNULL_END
