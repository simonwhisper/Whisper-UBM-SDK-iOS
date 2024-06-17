//
//  CPP_wrapper.h
//  WhisperUBM-SwiftSDK
//
//  Created by Whisper Developer on 10/06/2024.
//

#import <Foundation/Foundation.h>

@interface CPP_wrapper : NSObject

-(void) InitWhisperWave;

-(int)Decode:(const void *)waveformBuffer
              waveformSize:(int)waveformSize
             payloadBuffer:(void *)payloadBuffer
                    prefix:(NSString *)prefix;

@end
