//
//  ContentView.swift
//  LLM-Ap
//
//  Created by Andrey Zhuravlev on 24/11/25.
//

import SwiftUI
import FoundationModels
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var generator: Generator?
    @State private var text: String = "How are you?"
    @State private var textr: String = ""
    @State private var isPublishing: Bool = false
    @State var f: String = ""
    @State var g: String = ""
    @State var pr: String = ""
    private let model = SystemLanguageModel.default
    
    @State private var requested: Bool = false
    var body: some View {
        
        VStack {
            Text("LLM Prompt (up to 4 000 tokens):")
            TextEditor(text: $text)
                .frame(minHeight: 5)
                .frame(maxHeight: 115)
                .font(.system(size: 17.0))
                .border(Color.gray)
 
            Button("Generate"){
               
                f=""
                g=""
                Task { @MainActor in
                    pr=pr+textr+" "+text
                    let newGenerator = LLM_Ap.Generator(userprompt:pr)
                    newGenerator.prewarmModel()
                    self.generator = newGenerator
                    f = "Generating ..."
                    await newGenerator.generate(userprompt: pr)
                    // Update UI state after generation finishes
                    self.textr = newGenerator.result
                    f = "Generation completed"

                }
            }
            .background(Color.accentColor)
            
            Text(f)
                .font(.system(size: 17.0))
                .glassEffect()
            Text("Generated text:")
//            Text(generator?.result ?? "")
            TextEditor(text: $textr)
                .font(.system(size: 17.0))
                .border(Color.green)
            
            
 //Save generated text
            Button(action: {
                isPublishing = true
                f=""
            }, label: {
                Text("Save generated text to text file")
                    .font(.system(size: 14.0))
                    .glassEffect()
            })
            .fileExporter(
                isPresented: $isPublishing,
                document: TextFileDocument(text: pr+"\n --- \n"+textr),
                contentType: .plainText,
                defaultFilename: "generated_text.txt"
            ) { result in
                switch result {
                case .success:
                    g = "Text saved successfully"
                    break
                case .failure(let error):
                    g = ("Export failed: \(error)")
                }
            }
             
            Text(g)
            
            
            
        }
    }
}
#Preview {
    ContentView()
}
