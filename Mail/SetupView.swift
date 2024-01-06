//
//  SetupView.swift
//  Mail
//
//  Created by Nathan Lee on 3/1/2024.
//

import SwiftUI
import CoreData

struct SetupView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var sessionInfo: SessionInfo
    
    @State private var isIconTapped: Bool = false
    @State private var isNextTapped: Bool = false
    @State private var nextStepAllowed: Bool = true
    @State private var nextPageAllowed: Bool = true
    @State private var isNextDenied: Int = 0
    @State private var isTitlePage: Bool = true
    @State private var currentPage: Int = 0
    @State private var pageOffset: CGFloat = 160
    @State private var passwordHide: Bool = true
    @State private var isLoading: Bool = false
    @State private var buttonScale: Double = 1.0
    @State private var isLoginDenied: Int = 0
    
    @State private var enteredEmail: String = ""
    // = "nahtanlee@gmail.com"
    @State private var enteredPassword: String = ""
    // = "hrll hurc ikmb xwhl"
    

    
    var body: some View {
        let database = CoreDatabase(context: managedObjectContext)
        let shadowRadius: CGFloat = 10

        
        ZStack {
            
            // Combine header, page, page dots and next button
            VStack {
                // Header/Title
                VStack (spacing: 0) {
                    Spacer()
                    HStack (spacing: 0) {
                        Text("Welcome to Mail")
                            .font(.system(size: 42, weight: .heavy, design: .rounded))
                            .foregroundStyle(.primary)
                            .opacity(0.9)
                            .shadow(radius: shadowRadius)
                        VStack (spacing: 0){
                            Text("*")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundStyle(.primary)
                                .opacity(0.9)
                                .shadow(radius: shadowRadius)
                                .padding(.bottom, 5)
                            
                        }
                    }
                    
                    Text("*but better")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .opacity(0.9)
                        .shadow(radius: shadowRadius)
                }
                
                HStack (spacing: 0) {
                    // Title page (0)
                    if currentPage >= -1 && currentPage <= 1 {
                        VStack (spacing: 0) {
                            Image("Icon")
                                .frame(width: 150, height: 150, alignment: .center)
                                .shadow(radius: shadowRadius)
                                .offset(x: 0, y: isIconTapped ? 25 : 0)
                                .padding(.top, 50)
                                .padding(.bottom, 200)
                                .scaleEffect(isIconTapped ? 0.7 : 0.5)
                                .animation(Animation.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isIconTapped)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in isIconTapped = true }
                                        .onEnded { _ in isIconTapped = false }
                                )
                        }
                        .offset(x: pageOffset)
                    }
                    
                    // Login page (1)
                    if currentPage >= 0 && currentPage <= 2 {
                        VStack {
                            
                            Text("Login:")
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 310, alignment: .leading)
                                .foregroundStyle(.secondary.opacity(0.9))
                                .padding(.top, 100)
                            // Login fields
                            VStack (spacing: 4) {
                                // Email field
                                RoundedRectangle(cornerRadius: 25)
                                    .textFieldModifier()
                                    .frame(width: 310, height: 35)
                                    .overlay {
                                        TextField("Email address", text: $enteredEmail) { }
                                            .padding(.bottom, 4)
                                            .frame(width: 280, height: 25)
                                            .autocorrectionDisabled(true)
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.emailAddress)
                                            .offset(y: 2)
                                            .onSubmit {
                                                if enteredPassword != "" && validateEmail(enteredEmail){
                                                    nextStepAllowed = true
                                                    
                                                } else {
                                                    nextStepAllowed = false
                                                }
                                            }
                                    }
                                    .padding(.bottom, 4)
                                
                                // Password field
                                RoundedRectangle(cornerRadius: 25)
                                    .textFieldModifier()
                                    .frame(width: 310, height: 35)
                                    .overlay {
                                        HStack (spacing: 0){
                                            VStack (spacing: 0) {
                                                SecureField(text: $enteredPassword, prompt: Text("Password")) { }
                                                    .autocorrectionDisabled(true)
                                                    .textInputAutocapitalization(.never)
                                                    .frame(width: 250, height: 25)
                                                    .privacySensitive(true)
                                                    .offset(y: passwordHide ? 12.5 : -50)
                                                    .onSubmit {
                                                        if enteredPassword != "" && validateEmail(enteredEmail){
                                                            nextStepAllowed = true
                                                            
                                                        } else {
                                                            nextStepAllowed = false
                                                        }
                                                    }
                                                
                                                TextField(text: $enteredPassword, prompt: Text("Password")) { }
                                                    .autocorrectionDisabled(true)
                                                    .textInputAutocapitalization(.never)
                                                    .frame(width: 250, height: 25)
                                                    .privacySensitive(true)
                                                    .offset(y: passwordHide ? 50 : -12.5)
                                            }
                                            
                                            Image(systemName:  passwordHide ? "eye.slash.fill" : "eye.fill")
                                                .symbolRenderingMode(.palette)
                                                .contentTransition(.symbolEffect(.replace.downUp.byLayer))
                                                .foregroundStyle(.foreground.opacity(0.4))
                                                .gesture(
                                                    DragGesture(minimumDistance: 0.000000001)
                                                        .onChanged { _ in
                                                            withAnimation(.bouncy) {
                                                                passwordHide = false
                                                            }
                                                        }
                                                        .onEnded { _ in
                                                            withAnimation(.bouncy) {
                                                                passwordHide = true
                                                            }
                                                        }
                                                )
                                                .onTapGesture {
                                                    withAnimation(.bouncy) {
                                                        passwordHide.toggle()
                                                    }
                                                }
                                                .padding(.leading, 4)
                                        }
                                        .frame(width: 310, height: 35)
                                        .clipped()
                                    }
                                
                            }
                            .modifier(Shake(animatableData: CGFloat(isLoginDenied)))
                            .padding(.bottom, 275)
                            
                            
                            
                        }
                        .offset(x: pageOffset + 400)
                    }
                }
                
                
                // Page dots
                TabView(selection: $currentPage) {
                    Text("").tag(0)
                    Text("").tag(1)
                    //Text("").tag(2)
                }
                .frame(width: 400, height: 35, alignment: .center)
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .allowsHitTesting(false)
                
                // Button
            
                Button(action: {
                    if nextStepAllowed {
                        if nextPageAllowed {
                            nextPage()
                        } else {
                            nextStep() { success in
                                if success {
                                    database.write(entity: "Login", attribute: "setup", value: true, completion: { completion in
                                        if completion {
                                            print("Setup written to")
                                        }
                                    })
                                    print("Setup complete")
                                    withAnimation(.bouncy) {
                                        sessionInfo.loginSetup = true
                                    }
                                } else {
                                    withAnimation(.bouncy) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            print("Login Failed")
                                            isLoading = false
                                            isLoginDenied += 1
                                            nextPageAllowed = false
                                            nextStepAllowed = false
                                        }
                                    }
                                }
                            }
                            

                        }
                    } else {
                        if isLoading {
                            withAnimation(.bouncy) {
                                buttonScale = 1.4
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.bouncy) {
                                    buttonScale = 1.0
                                }
                            }
                        } else {
                            withAnimation(.default) {
                                isNextDenied += 1
                            }
                        }
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundStyle(nextStepAllowed ? Color.blue : Color.black.opacity(0.1))
                            .frame(width: isLoading ? 35 : 85, height: 35)
                            
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .scaleEffect(1)
                            } else {
                                Text("Next")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                
                                Image(systemName: "chevron.right")
                                    .bold()
                            }
                        }
                    }
                    .modifier(Shake(animatableData: CGFloat(isNextDenied)))
                })
                .scaleEffect(buttonScale)
                .tint(nextStepAllowed ? .white : .gray)
                .padding(.bottom, 25)
                    
                
                    
            }

            
        }
        .ignoresSafeArea(.keyboard)
        
        
    }
    
    private func nextPage() {
        withAnimation(.bouncy) {
            nextStepAllowed = false
            nextPageAllowed = false
            currentPage += 1
            pageOffset = pageOffset - 635
        }
    }
    
    private func nextStep(completion: @escaping (Bool) -> Void) {
        let database = CoreDatabase(context: managedObjectContext)
        withAnimation(.bouncy) {
            nextStepAllowed = false
            isLoading = true
        }
        if currentPage == 1 {
            
            @State var emailSaved: Bool = false
            @State var passwordSaved: Bool = false
            database.write(entity: "Login", attribute: "email", value: enteredEmail) { completed in
                if completed {
                    print("Email saved")
                    emailSaved = true
                }
            }
            database.write(entity: "Login", attribute: "password", value: enteredPassword) { completed in
                if completed {
                    print("Password saved")
                    passwordSaved = true
                    checkSession(database: database) { completed in
                        if completed {
                            print("Valid session")
                            completion(true)
                        } else {
                            print("Invalid session")
                            completion(false)
                        }
                    }
                }
            }
            
            // validate login
        }
    }
}


// Next button shake effect
struct Shake: GeometryEffect {
    var amount: CGFloat = 7
    var shakesPerUnit = 4
    var animatableData: CGFloat
    

    func effectValue(size: CGSize) -> ProjectionTransform {

        let translation = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))

    }
}


extension Shape {
    func textFieldModifier() -> some View {
        self
            .fill(.shadow(.inner(radius: 1, x: 0, y: 1.5)))
            .stroke(LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottom).opacity(0.3), lineWidth: 1)
            .foregroundStyle(.background.opacity(0.2))
    }
}

func validateEmail(_ email: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
    return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
}

#Preview {
    SetupView()
}
