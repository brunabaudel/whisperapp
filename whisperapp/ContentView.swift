//
//  ContentView.swift
//  whisperapp
//
//  Created by Bruna Baudel on 21/01/2023.
//

import SwiftUI
import whisper

struct ContentView: View {
    
    init() {
        let stringPath = Bundle.main.path(forResource: "models/for-tests-ggml-base.en", ofType: "bin")

        let ctx = whisper_init_from_file(stringPath)
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        
        params.print_realtime   = true
        params.print_progress   = false
        params.print_timestamps = true
        params.print_special    = false
        params.translate        = false
        params.language         = NSString("en").utf8String
        params.n_threads        = 4
        params.offset_ms        = 0
        
        let n_samples = Int32(WHISPER_SAMPLE_RATE)
        let pcmf32 = [Float](repeating: 0, count: Int(n_samples))

        let ret = whisper_full(ctx, params, pcmf32, n_samples)
        assert(ret == 0, "Failed to run the model")

        let n_segments = whisper_full_n_segments(ctx)

        for i in 0..<n_segments {
            let text_cur = whisper_full_get_segment_text(ctx, i)
            print(text_cur as Any)
        }
        
        whisper_print_timings(ctx)
        whisper_free(ctx)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
