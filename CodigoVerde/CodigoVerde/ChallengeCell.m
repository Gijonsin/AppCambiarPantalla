//
//  ChallengeCell.m
//  CodigoVerde
//
//  Created by Guest User on 01/12/25.
//

#import "ChallengeCell.h"

@implementation ChallengeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Esta es la acción que conectaremos al evento "Value Changed" del selector
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    
    // Si alguien (el ViewController) está escuchando...
    if (self.statusChangedBlock) {
        
        // Verificamos cuál segmento se eligió.
        // Asumiendo que el segmento 0 es "Completed" y el 1 es "In Progress"
        BOOL completed = (sender.selectedSegmentIndex == 0);
        
        // ¡Avisamos!
        self.statusChangedBlock(completed);
    }
}

@end
