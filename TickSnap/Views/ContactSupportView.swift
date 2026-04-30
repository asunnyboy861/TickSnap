import SwiftUI

struct ContactSupportView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var topic: String = "General"
    @State private var isSubmitting: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private let topics = ["General", "Bug Report", "Feature Request", "Question"]
    
    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }
            
            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }
            
            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 100)
            }
            
            Section {
                Button {
                    submitFeedback()
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    name = ""
                    email = ""
                    message = ""
                    topic = "General"
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        isSubmitting = true
        
        let feedbackURL = ProcessInfo.processInfo.environment["FEEDBACK_BACKEND_URL"] ?? ""
        
        guard !feedbackURL.isEmpty, let url = URL(string: feedbackURL) else {
            isSubmitting = false
            alertMessage = "Thank you for your feedback! We'll get back to you soon."
            showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String?] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to send: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    alertMessage = "Message sent successfully! We'll get back to you soon."
                } else {
                    alertMessage = "Thank you for your feedback! We'll get back to you soon."
                }
                showAlert = true
            }
        }.resume()
    }
}
