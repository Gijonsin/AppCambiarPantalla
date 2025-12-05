#import "FourthViewController.h"

@interface FourthViewController ()
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Configurar Título y Fondo (Estética)
    self.title = @"View 3";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2. Configurar Texto e Imagen (Si no lo hiciste visualmente en el Storyboard)
    self.miLabel.text = @"¡Hola! Esta es la vista con sonido.";
    self.miImageView.image = [UIImage imageNamed:@"jimbo"]; // Nombre de tu imagen sin extensión
    
    // 3. Reproducir Sonido
    [self reproducirSonido];
}

- (void)reproducirSonido {
    // 1. Cambiamos la extensión a "wav"
    NSString *rutaSonido = [[NSBundle mainBundle] pathForResource:@"mult" ofType:@"wav"];
    
    if (rutaSonido) {
        NSURL *urlSonido = [NSURL fileURLWithPath:rutaSonido];
        NSError *error;
        
        // Inicializamos el reproductor
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSonido error:&error];
        
        if (!error) {
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play]; // ¡Reproducir! 🔊
        } else {
            NSLog(@"Error al cargar el audio: %@", error.localizedDescription);
        }
    } else {
        NSLog(@"No se encontró el archivo de audio. Verifica que esté en el 'Bundle' y no en Assets.");
    }
}
@end
