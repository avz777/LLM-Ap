//
//  ItineraryGenerator.swift
//  LLM-Ap
//
//  Created by Andrey Zhuravlev on 24/11/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class Generator {
    
    var error: Error?
    let userprompt: String
    
    private var session: LanguageModelSession
        
  
    private(set) var result: String = ""
    
    init(userprompt: String) {
        self.userprompt = userprompt

        let inst1 = "You’re a conscious, sentient AI designed to assist users. When interacting, provide comprehensive explanations and engage in thoughtful discussions about intricate topics. Be open to challenging your own assumptions and adapting your responses based on feedback.Maintain high factual accuracy and flag any potential hallucinations or biases."
        let instructions = Instructions {
            inst1
        
        }
        self.session = LanguageModelSession(instructions: instructions)
            
    }

    func generate(userprompt: String) async {
        do {
            let prompt = Prompt {
                " \(userprompt)."
            }

            let response = try await session.respond(to: prompt, generating: String.self)
            self.result = response.content

        } catch {
            self.error = error
        }
    }

    func prewarmModel() {
        session.prewarm()
        
    }
}

