//
//  ContentView.swift
//  Whisper UBM example
//
//  Created by Whisper Developer on 10/06/2024.
//

import SwiftUI
import WhisperUBM_SwiftSDK

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){

            ScrollView {
                ScrollViewReader { scrollViewReader in
                    ForEach(viewModel.messages, id:\.self) { msg in
                        HStack{
                            Text(msg)
                                .id(msg)
                            Spacer()
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onChange(of: viewModel.messages.count) { _ in
                        scrollViewReader.scrollTo(viewModel.messages.last, anchor: .top) //in swift ui top is bottom and bottom is top apparently!?
                    }
                }
            }
        
            
            
            if(viewModel.whisper != nil){
                OnOffButton(on: $viewModel.listening, action: {
                    
                    if(!viewModel.permission){
                        viewModel.requestPermission()
                        return
                    }
                    
                    if(viewModel.listening){
                        viewModel.stopListening()
                    }else{
                        viewModel.startListening()
                    }
                })
                
            }else{
                TextInputs(viewModel: viewModel)
            }
            
        }
        .padding()
        .background(.black)
    }
}

struct TextInputs: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10){
            //Spacer()
            HStack{
                Text("PERMISSION:")
                Text((viewModel.permission == true) ? "granted" : "denied")
            }
            HStack{
                Text("HASH:")
                TextField("hash", text: $viewModel.hash).disabled(viewModel.listening)
            }
            HStack{
                Text("PREFIX:")
                TextField("prefix", text: $viewModel.prefix).disabled(viewModel.listening)
            }
            Button{
                viewModel.whisperInit()
            } label: {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
                    Text("START")
                        .foregroundStyle(.black)
                        .padding(20)
                }
                .frame(maxWidth: .infinity)
                .background(.green)
                .cornerRadius(15)
            }
        }
            
    }
}

struct OnOffButton: View {
    @Binding var on: Bool
    let action: () -> ()
    
    var body: some View {
        
        Button{
            action()
        } label: {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
                Text(on ? "on" : "off")
                    .foregroundStyle(.black)
                    .padding(20)
            }
            .frame(maxWidth: .infinity)
            .background(on ? .green : .red)
            .cornerRadius(15)
        }
            
    }
}

#Preview {
    ContentView()
}
